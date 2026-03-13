"""
CHARI-PI Backend API Server
管理用Webダッシュボード + Flutter アプリ向けREST API
e-Gov法令検索API連携・コンテンツCMS機能付き
"""
import json
import os
import uuid
import hashlib
from datetime import datetime, timezone
from functools import wraps

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS

app = Flask(__name__, static_folder='admin_dashboard', static_url_path='/admin')
CORS(app)

DATA_DIR = os.path.join(os.path.dirname(__file__), 'data')
ADMIN_PASSWORD_HASH = hashlib.sha256('charipi_admin_2025'.encode()).hexdigest()

# --- Data helpers ---
def load_json(filename):
    filepath = os.path.join(DATA_DIR, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    return []

def save_json(filename, data):
    filepath = os.path.join(DATA_DIR, filename)
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

# Simple auth
def require_admin(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.headers.get('Authorization', '')
        if auth.startswith('Bearer '):
            token = auth[7:]
            if token == ADMIN_PASSWORD_HASH:
                return f(*args, **kwargs)
        return jsonify({'error': 'Unauthorized'}), 401
    return decorated

# ==================== PUBLIC API (Flutter App) ====================

@app.route('/api/v1/rules', methods=['GET'])
def get_rules():
    """公開ルール一覧取得（アプリ側）"""
    rules = load_json('rules.json')
    published = [r for r in rules if r.get('is_published', False)]
    category = request.args.get('category')
    if category:
        published = [r for r in published if r.get('category') == category]
    return jsonify({
        'data': published,
        'total': len(published),
        'last_updated': max((r.get('updated_at', '') for r in published), default=''),
    })

@app.route('/api/v1/rules/<rule_id>', methods=['GET'])
def get_rule(rule_id):
    """ルール詳細取得"""
    rules = load_json('rules.json')
    rule = next((r for r in rules if r['id'] == rule_id and r.get('is_published')), None)
    if not rule:
        return jsonify({'error': 'Not found'}), 404
    return jsonify({'data': rule})

@app.route('/api/v1/quizzes', methods=['GET'])
def get_quizzes():
    """クイズ一覧取得"""
    quizzes = load_json('quizzes.json')
    category = request.args.get('category')
    difficulty = request.args.get('difficulty')
    if category:
        quizzes = [q for q in quizzes if q.get('category') == category]
    if difficulty:
        quizzes = [q for q in quizzes if q.get('difficulty') == difficulty]
    count = request.args.get('count')
    if count:
        import random
        quizzes = random.sample(quizzes, min(int(count), len(quizzes)))
    return jsonify({'data': quizzes, 'total': len(quizzes)})

@app.route('/api/v1/law-updates', methods=['GET'])
def get_law_updates():
    """法改正情報一覧取得"""
    updates = load_json('law_updates.json')
    published = [u for u in updates if u.get('is_published', False)]
    published.sort(key=lambda x: x.get('published_at', ''), reverse=True)
    return jsonify({'data': published, 'total': len(published)})

@app.route('/api/v1/categories', methods=['GET'])
def get_categories():
    """カテゴリ一覧取得"""
    categories = {
        'basic': {'name': '基本ルール', 'icon': 'menu_book', 'color': '#2979FF'},
        'intersection': {'name': '交差点・信号', 'icon': 'traffic', 'color': '#FF9800'},
        'road': {'name': '道路走行', 'icon': 'add_road', 'color': '#76FF03'},
        'equipment': {'name': '装備・車体', 'icon': 'build', 'color': '#00E5FF'},
        'prohibition': {'name': '禁止事項', 'icon': 'do_not_disturb', 'color': '#F44336'},
        'safety': {'name': '安全対策', 'icon': 'health_and_safety', 'color': '#4CAF50'},
        'insurance': {'name': '保険', 'icon': 'security', 'color': '#9C27B0'},
        'new_law': {'name': '新制度', 'icon': 'new_releases', 'color': '#E91E63'},
        'registration': {'name': '登録', 'icon': 'app_registration', 'color': '#607D8B'},
    }
    return jsonify({'data': categories})

@app.route('/api/v1/stats', methods=['GET'])
def get_stats():
    """統計情報"""
    rules = load_json('rules.json')
    quizzes = load_json('quizzes.json')
    updates = load_json('law_updates.json')
    published_rules = [r for r in rules if r.get('is_published')]
    return jsonify({
        'total_rules': len(published_rules),
        'total_quizzes': len(quizzes),
        'total_updates': len([u for u in updates if u.get('is_published')]),
        'categories': list(set(r.get('category', '') for r in published_rules)),
    })

# ==================== ADMIN API (Dashboard) ====================

@app.route('/api/admin/login', methods=['POST'])
def admin_login():
    """管理者ログイン"""
    data = request.get_json() or {}
    password = data.get('password', '')
    pw_hash = hashlib.sha256(password.encode()).hexdigest()
    if pw_hash == ADMIN_PASSWORD_HASH:
        return jsonify({'token': ADMIN_PASSWORD_HASH, 'message': 'Login successful'})
    return jsonify({'error': 'Invalid password'}), 401

# --- Rules CRUD ---
@app.route('/api/admin/rules', methods=['GET'])
@require_admin
def admin_get_rules():
    """全ルール一覧（下書き含む）"""
    rules = load_json('rules.json')
    return jsonify({'data': rules, 'total': len(rules)})

@app.route('/api/admin/rules', methods=['POST'])
@require_admin
def admin_create_rule():
    """ルール新規作成"""
    data = request.get_json() or {}
    rules = load_json('rules.json')
    now = datetime.now(timezone.utc).isoformat()
    new_rule = {
        'id': f'rule_{str(uuid.uuid4())[:8]}',
        'title': data.get('title', ''),
        'icon': data.get('icon', 'article'),
        'category': data.get('category', 'basic'),
        'summary': data.get('summary', ''),
        'content': data.get('content', ''),
        'key_points': data.get('key_points', []),
        'law_reference': data.get('law_reference', ''),
        'source_url': data.get('source_url', ''),
        'penalty': data.get('penalty', ''),
        'is_published': data.get('is_published', False),
        'version': 1,
        'created_at': now,
        'updated_at': now,
    }
    rules.append(new_rule)
    save_json('rules.json', rules)
    return jsonify({'data': new_rule, 'message': 'Rule created'}), 201

@app.route('/api/admin/rules/<rule_id>', methods=['PUT'])
@require_admin
def admin_update_rule(rule_id):
    """ルール更新"""
    data = request.get_json() or {}
    rules = load_json('rules.json')
    rule = next((r for r in rules if r['id'] == rule_id), None)
    if not rule:
        return jsonify({'error': 'Not found'}), 404
    for key in ['title', 'icon', 'category', 'summary', 'content', 'key_points',
                'law_reference', 'source_url', 'penalty', 'is_published']:
        if key in data:
            rule[key] = data[key]
    rule['version'] = rule.get('version', 0) + 1
    rule['updated_at'] = datetime.now(timezone.utc).isoformat()
    save_json('rules.json', rules)
    return jsonify({'data': rule, 'message': 'Rule updated'})

@app.route('/api/admin/rules/<rule_id>', methods=['DELETE'])
@require_admin
def admin_delete_rule(rule_id):
    """ルール削除"""
    rules = load_json('rules.json')
    rules = [r for r in rules if r['id'] != rule_id]
    save_json('rules.json', rules)
    return jsonify({'message': 'Rule deleted'})

# --- Quizzes CRUD ---
@app.route('/api/admin/quizzes', methods=['GET'])
@require_admin
def admin_get_quizzes():
    quizzes = load_json('quizzes.json')
    return jsonify({'data': quizzes, 'total': len(quizzes)})

@app.route('/api/admin/quizzes', methods=['POST'])
@require_admin
def admin_create_quiz():
    data = request.get_json() or {}
    quizzes = load_json('quizzes.json')
    new_quiz = {
        'id': f'q{str(uuid.uuid4())[:8]}',
        'question': data.get('question', ''),
        'options': data.get('options', []),
        'correct_index': data.get('correct_index', 0),
        'explanation': data.get('explanation', ''),
        'rule_id': data.get('rule_id', ''),
        'category': data.get('category', 'basic'),
        'difficulty': data.get('difficulty', 'easy'),
    }
    quizzes.append(new_quiz)
    save_json('quizzes.json', quizzes)
    return jsonify({'data': new_quiz, 'message': 'Quiz created'}), 201

@app.route('/api/admin/quizzes/<quiz_id>', methods=['PUT'])
@require_admin
def admin_update_quiz(quiz_id):
    data = request.get_json() or {}
    quizzes = load_json('quizzes.json')
    quiz = next((q for q in quizzes if q['id'] == quiz_id), None)
    if not quiz:
        return jsonify({'error': 'Not found'}), 404
    for key in ['question', 'options', 'correct_index', 'explanation', 'rule_id', 'category', 'difficulty']:
        if key in data:
            quiz[key] = data[key]
    save_json('quizzes.json', quizzes)
    return jsonify({'data': quiz, 'message': 'Quiz updated'})

@app.route('/api/admin/quizzes/<quiz_id>', methods=['DELETE'])
@require_admin
def admin_delete_quiz(quiz_id):
    quizzes = load_json('quizzes.json')
    quizzes = [q for q in quizzes if q['id'] != quiz_id]
    save_json('quizzes.json', quizzes)
    return jsonify({'message': 'Quiz deleted'})

# --- Law Updates CRUD ---
@app.route('/api/admin/law-updates', methods=['GET'])
@require_admin
def admin_get_law_updates():
    updates = load_json('law_updates.json')
    return jsonify({'data': updates, 'total': len(updates)})

@app.route('/api/admin/law-updates', methods=['POST'])
@require_admin
def admin_create_law_update():
    data = request.get_json() or {}
    updates = load_json('law_updates.json')
    new_update = {
        'id': f'update_{str(uuid.uuid4())[:8]}',
        'title': data.get('title', ''),
        'summary': data.get('summary', ''),
        'law_reference': data.get('law_reference', ''),
        'source_url': data.get('source_url', ''),
        'effective_date': data.get('effective_date', ''),
        'published_at': datetime.now(timezone.utc).isoformat(),
        'is_published': data.get('is_published', False),
    }
    updates.append(new_update)
    save_json('law_updates.json', updates)
    return jsonify({'data': new_update, 'message': 'Law update created'}), 201

@app.route('/api/admin/law-updates/<update_id>', methods=['PUT'])
@require_admin
def admin_update_law_update(update_id):
    data = request.get_json() or {}
    updates = load_json('law_updates.json')
    update = next((u for u in updates if u['id'] == update_id), None)
    if not update:
        return jsonify({'error': 'Not found'}), 404
    for key in ['title', 'summary', 'law_reference', 'source_url', 'effective_date', 'is_published']:
        if key in data:
            update[key] = data[key]
    save_json('law_updates.json', updates)
    return jsonify({'data': update, 'message': 'Law update updated'})

@app.route('/api/admin/law-updates/<update_id>', methods=['DELETE'])
@require_admin
def admin_delete_law_update(update_id):
    updates = load_json('law_updates.json')
    updates = [u for u in updates if u['id'] != update_id]
    save_json('law_updates.json', updates)
    return jsonify({'message': 'Law update deleted'})

# ==================== e-Gov API Proxy ====================

@app.route('/api/v1/egov/law/<law_num>', methods=['GET'])
def egov_law_lookup(law_num):
    """e-Gov法令検索APIプロキシ - 道路交通法の条文取得"""
    import urllib.request
    import urllib.error
    try:
        url = f'https://laws.e-gov.go.jp/api/2/law_data/{law_num}'
        req = urllib.request.Request(url, headers={'Accept': 'application/json'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            return jsonify({'data': data, 'source': 'e-Gov法令検索API'})
    except urllib.error.HTTPError as e:
        return jsonify({'error': f'e-Gov API error: {e.code}', 'message': str(e)}), 502
    except Exception as e:
        return jsonify({'error': 'Failed to fetch from e-Gov API', 'message': str(e)}), 502

@app.route('/api/v1/egov/search', methods=['GET'])
def egov_search():
    """e-Gov法令検索"""
    keyword = request.args.get('keyword', '')
    if not keyword:
        return jsonify({'error': 'keyword parameter required'}), 400
    import urllib.request
    import urllib.parse
    try:
        encoded = urllib.parse.quote(keyword)
        url = f'https://laws.e-gov.go.jp/api/2/law_list?keyword={encoded}&category=1'
        req = urllib.request.Request(url, headers={'Accept': 'application/json'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            return jsonify({'data': data, 'source': 'e-Gov法令検索API'})
    except Exception as e:
        return jsonify({'error': 'Search failed', 'message': str(e)}), 502

# ==================== Admin Dashboard SPA ====================

@app.route('/admin')
@app.route('/admin/')
def admin_dashboard():
    return send_from_directory('admin_dashboard', 'index.html')

@app.route('/')
def index():
    return jsonify({
        'name': 'CHARI-PI API Server',
        'version': '1.0.0',
        'endpoints': {
            'rules': '/api/v1/rules',
            'quizzes': '/api/v1/quizzes',
            'law_updates': '/api/v1/law-updates',
            'categories': '/api/v1/categories',
            'stats': '/api/v1/stats',
            'admin': '/admin/',
        }
    })

if __name__ == '__main__':
    os.makedirs(DATA_DIR, exist_ok=True)
    app.run(host='0.0.0.0', port=5080, debug=False)
