class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class QuizData {
  static const List<QuizQuestion> questions = [
    QuizQuestion(
      question: '自転車は道路のどちら側を走行しますか？',
      options: ['右側', '左側', 'どちらでもよい', '中央'],
      correctIndex: 1,
      explanation: '自転車は車両なので、道路の左側を走行する義務があります（道路交通法第17条）。',
    ),
    QuizQuestion(
      question: '一時停止の標識がある交差点では、自転車はどうすべきですか？',
      options: ['徐行して通過', '完全に停止してから安全確認', 'ベルを鳴らして通過', '歩行者がいなければ通過可能'],
      correctIndex: 1,
      explanation: '一時停止の標識では、必ず完全に停止し、左右の安全を確認してから通行します。',
    ),
    QuizQuestion(
      question: '自転車で歩道を走行できる条件は？',
      options: [
        'いつでも走行可能',
        '「自転車通行可」の標識がある場合のみ',
        '歩行者がいない場合のみ',
        '雨の日だけ'
      ],
      correctIndex: 1,
      explanation: '歩道は原則走行禁止です。「自転車通行可」の標識がある場合、13歳未満・70歳以上、車道が危険な場合に限り通行できます。',
    ),
    QuizQuestion(
      question: '夜間の自転車走行で義務付けられているものは？',
      options: ['ヘルメット', '前照灯と尾灯（反射板）', '反射ベスト', 'ベル'],
      correctIndex: 1,
      explanation: '夜間は前照灯の点灯と尾灯または反射板の装着が義務です（道路交通法第52条）。',
    ),
    QuizQuestion(
      question: '自転車でイヤホンをつけて走行することは？',
      options: ['許可されている', '片耳なら許可', '多くの都道府県で禁止', '音量が小さければ許可'],
      correctIndex: 2,
      explanation: '多くの都道府県の条例で、イヤホン等を使用して安全な運転に必要な音が聞こえない状態での運転は禁止されています。',
    ),
    QuizQuestion(
      question: '自転車の飲酒運転の罰則は？',
      options: ['罰則なし', '5万円以下の罰金', '5年以下の懲役または100万円以下の罰金', '注意のみ'],
      correctIndex: 2,
      explanation: '自転車も車両です。飲酒運転は5年以下の懲役または100万円以下の罰金が科されます。',
    ),
    QuizQuestion(
      question: '自転車の二人乗りが許可される条件は？',
      options: [
        '短距離なら許可',
        '幼児用座席に6歳未満の子供を乗せる場合',
        '大人同士でも許可',
        '全面的に禁止'
      ],
      correctIndex: 1,
      explanation: '16歳以上の運転者が、幼児用座席に6歳未満の幼児を1人乗せる場合に限り許可されます。',
    ),
    QuizQuestion(
      question: '信号機のない横断歩道に歩行者がいた場合、自転車は？',
      options: ['そのまま通過', 'ベルを鳴らして通過', '一時停止して歩行者を優先', '歩行者に避けてもらう'],
      correctIndex: 2,
      explanation: '横断歩道では歩行者が最優先です。歩行者がいる場合は必ず一時停止しなければなりません。',
    ),
    QuizQuestion(
      question: '自転車の傘差し運転は？',
      options: ['雨の日なら許可', '多くの都道府県で禁止', '風が強くなければ許可', '許可されている'],
      correctIndex: 1,
      explanation: '傘差し運転は片手運転となり危険です。多くの都道府県の条例で禁止されています。レインコートを着用しましょう。',
    ),
    QuizQuestion(
      question: '2023年4月から自転車のヘルメット着用は？',
      options: ['義務化された', '努力義務化された', '推奨のまま', '13歳未満のみ義務'],
      correctIndex: 1,
      explanation: '2023年4月1日から、全ての自転車利用者にヘルメットの着用が努力義務化されました（道路交通法第63条の11）。',
    ),
  ];
}
