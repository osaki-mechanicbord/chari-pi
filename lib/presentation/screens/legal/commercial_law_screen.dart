import 'package:flutter/material.dart';
import 'legal_page_screen.dart';
import '../../../core/constants/colors.dart';

class CommercialLawScreen extends StatelessWidget {
  const CommercialLawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScreen(
      title: '特定商取引法に基づく表記',
      children: [
        const LegalLastUpdated('2025年7月15日'),
        const LegalParagraph(
          '特定商取引に関する法律（特定商取引法）第11条に基づき、以下の事項を表示いたします。',
        ),

        // 事業者情報テーブル
        const LegalSectionTitle('事業者情報'),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Column(
            children: [
              LegalTableRow(label: '販売事業者', value: '株式会社TCI'),
              LegalTableRow(label: '代表者', value: '代表取締役 大崎 雄斗'),
              LegalTableRow(label: '所在地', value: '〒532-0033\n大阪府大阪市淀川区新高1-5-4'),
              LegalTableRow(label: 'メール', value: 'info@tci-corp.co.jp'),
              LegalTableRow(
                label: '電話番号',
                value: 'お問い合わせはメールにて承ります\n※電話番号はご請求に応じて遅滞なく開示いたします',
              ),
              LegalTableRow(label: '営業時間', value: '平日 10:00〜17:00\n（土日祝・年末年始を除く）'),
            ],
          ),
        ),

        // 販売価格
        const LegalSectionTitle('販売価格（税込）'),
        const LegalParagraph('本アプリの有料プランは以下の料金体系です。'),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Column(
            children: [
              LegalTableRow(label: '無料プラン', value: '¥0\n基本ナビゲーション・学習機能\nGPS見守り（1名まで）'),
              LegalTableRow(label: 'ファミリー\nプラン', value: '月額 ¥480（税込）\n家族見守り（最大5名）\n安全スコア・ライドレポート'),
              LegalTableRow(label: '法人プラン', value: '月額 ¥980（税込）\n従業員安全管理（最大50名）\nダッシュボード・一括管理'),
            ],
          ),
        ),
        const LegalInfoBox(
          '上記価格はすべて消費税（10%）込みの表示です。決済はGoogle Play / App Storeのアプリ内課金を通じて行われます。',
          icon: Icons.receipt_long,
        ),

        // 支払方法
        const LegalSectionTitle('支払方法'),
        const LegalBullet('Google Play決済（Android）'),
        const LegalBullet('App Store決済（iOS）'),
        const LegalBullet('クレジットカード（各ストア対応カード）'),
        const LegalBullet('キャリア決済（各ストア対応キャリア）'),
        const LegalInfoBox(
          '2025年12月施行のスマホソフトウェア競争促進法に基づき、アプリ外決済手段を今後提供する可能性があります。導入時は別途ご案内いたします。',
          icon: Icons.info_outline,
        ),

        // 支払時期
        const LegalSectionTitle('支払時期'),
        const LegalParagraph(
          '有料プランの申込時に初回の月額料金が課金されます。以降、申込日を起算日として毎月自動的に課金されます。',
        ),

        // 商品等の引渡時期
        const LegalSectionTitle('サービスの提供時期'),
        const LegalParagraph(
          '有料プランへのアップグレード完了後、直ちにすべての有料機能がご利用いただけます。サーバーメンテナンス等により一時的に利用できない場合があります。',
        ),

        // 返品・キャンセル
        const LegalSectionTitle('返品・キャンセルについて'),
        const LegalParagraph(
          'デジタルコンテンツの性質上、サービス提供開始後の返金は原則としていたしかねます。ただし、以下の場合を除きます。',
        ),
        const LegalBullet('当社の重大な過失によりサービスが提供できない場合'),
        const LegalBullet('各ストアの返金ポリシーに該当する場合'),
        const LegalBullet('消費者契約法に基づく取消しが認められる場合'),

        // 解約
        const LegalSectionTitle('解約について'),
        const LegalBullet('有料プランの解約はいつでも可能です'),
        const LegalBullet('解約手続きは各ストア（Google Play / App Store）のサブスクリプション管理画面から行えます'),
        const LegalBullet('解約後も、課金期間の末日までサービスをご利用いただけます'),
        const LegalBullet('解約月の日割り返金はいたしかねます'),
        const LegalInfoBox(
          '解約を忘れた場合でも、各ストアの規約に基づき対応いたします。ご不明な点はお問い合わせください。',
          icon: Icons.help_outline,
        ),

        // 動作環境
        const LegalSectionTitle('動作環境'),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Column(
            children: [
              LegalTableRow(label: 'Android', value: 'Android 8.0以上\nGPS搭載端末'),
              LegalTableRow(label: 'iOS', value: 'iOS 15.0以上\nGPS搭載端末'),
              LegalTableRow(label: '通信環境', value: 'インターネット接続（4G/5G/Wi-Fi）\n※ナビ利用時は常時接続推奨'),
              LegalTableRow(label: '必要権限', value: '位置情報（GPS）\n通知\nバックグラウンド位置情報（見守り機能利用時）'),
            ],
          ),
        ),

        // 販売数量の制限等
        const LegalSectionTitle('販売数量の制限'),
        const LegalParagraph(
          '本サービスに販売数量の制限はありません。ただし、法人プランの同時利用人数は契約プランの上限に従います。',
        ),

        // 特別の販売条件
        const LegalSectionTitle('特別な販売条件'),
        const LegalBullet('ファミリープランは18歳以上の方のみお申し込みいただけます'),
        const LegalBullet('法人プランは法人・団体のみお申し込みいただけます'),
        const LegalBullet('無料プランの見守り機能（1名）は、双方の同意が必要です'),
        const LegalBullet('見守り機能の悪用（ストーカー行為等）が判明した場合、アカウントを即時停止します'),

        // 免責・瑕疵担保
        const LegalSectionTitle('瑕疵担保責任'),
        const LegalParagraph(
          '本サービスに重大な瑕疵があり、正常にご利用いただけない場合は、修正対応または利用料金の返金にて対応いたします。ただし、GPS精度や地図データの誤差等、技術的な制約に起因する問題は瑕疵に含みません。',
        ),

        // お問い合わせ
        const LegalSectionTitle('お問い合わせ窓口'),
        const LegalInfoBox(
          '特定商取引法に関するお問い合わせ\n\n株式会社TCI\nメール: info@tci-corp.co.jp\n所在地: 大阪府大阪市淀川区新高1-5-4\n\n受付時間: 平日 10:00〜17:00\n※お問い合わせへの回答は、通常3営業日以内にメールにてご返信いたします。',
          icon: Icons.support_agent,
          color: AppColors.accentCyan,
        ),
      ],
    );
  }
}
