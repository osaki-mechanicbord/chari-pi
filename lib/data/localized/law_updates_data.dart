/// ロケールに応じた法改正情報を返す
List<Map<String, dynamic>> buildLocalizedLawUpdates(String localeCode) {
  switch (localeCode) {
    case 'en':
      return _en;
    case 'ko':
      return _ko;
    case 'zh':
      return _zh;
    case 'vi':
      return _vi;
    case 'th':
      return _th;
    case 'fil':
      return _fil;
    case 'ja':
    default:
      return _ja;
  }
}

const _ja = [
  {
    'title': '自転車の「青切符」制度が開始',
    'summary': '2024年11月1日から自転車にも交通反則通告制度（青切符）が導入。16歳以上が対象で、信号無視6,000円、一時不停止5,000円等の反則金。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'ながらスマホの罰則強化',
    'summary': '自転車のながらスマホに6ヶ月以下の懲役又は10万円以下の罰金。交通危険を生じさせた場合は1年以下の懲役又は30万円以下の罰金。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '酒気帯び運転の罰則新設',
    'summary': '自転車の酒気帯び運転に3年以下の懲役又は50万円以下の罰金の罰則が新設。従来の酒酔い運転に加え、酒気帯びも処罰対象に。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '全年齢ヘルメット着用努力義務化',
    'summary': '2023年4月1日から全ての自転車利用者にヘルメット着用が努力義務化。罰則はないが、頭部致命傷リスクの大幅な軽減効果あり。',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _en = [
  {
    'title': 'Bicycle "Blue Ticket" System Starts',
    'summary': 'From Nov 1, 2024, traffic violation tickets (blue tickets) apply to bicycles. For ages 16+: running red light 6,000 yen, failure to stop 5,000 yen.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Stricter Smartphone Use Penalties',
    'summary': 'Using a smartphone while cycling: up to 6 months imprisonment or 100,000 yen fine. If causing traffic danger: up to 1 year or 300,000 yen.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'New Tipsy Driving Penalties',
    'summary': 'New penalties for cycling under the influence of alcohol: up to 3 years imprisonment or 500,000 yen fine.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Helmet Effort Obligation for All Ages',
    'summary': 'From Apr 1, 2023, wearing a helmet is an effort obligation for all cyclists. No penalty, but significantly reduces fatal head injury risk.',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _ko = [
  {
    'title': '자전거 "청색 딱지" 제도 시행',
    'summary': '2024년 11월 1일부터 자전거에도 교통반칙통고제도(청색 딱지)가 도입. 16세 이상 대상, 신호 무시 6,000엔, 일시정지 위반 5,000엔 등.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '스마트폰 사용 벌칙 강화',
    'summary': '자전거 스마트폰 사용 운전에 6개월 이하 징역 또는 10만엔 이하 벌금. 교통 위험을 초래한 경우 1년 이하 징역 또는 30만엔 이하 벌금.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '주기대 운전 벌칙 신설',
    'summary': '자전거 주기대 운전에 3년 이하 징역 또는 50만엔 이하 벌금 벌칙이 신설. 기존 주취 운전에 더해 주기대도 처벌 대상.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '전 연령 헬멧 착용 노력의무화',
    'summary': '2023년 4월 1일부터 모든 자전거 이용자에게 헬멧 착용이 노력의무화. 벌칙은 없으나 두부 치명상 위험 대폭 경감 효과.',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _zh = [
  {
    'title': '自行车"蓝色罚单"制度开始',
    'summary': '2024年11月1日起自行车也引入交通违章通知制度（蓝色罚单）。16岁以上为对象，闯红灯6,000日元、未停车5,000日元等。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '骑车使用手机处罚加强',
    'summary': '骑车使用手机处6个月以下有期徒刑或10万日元以下罚款。造成交通危险时处1年以下有期徒刑或30万日元以下罚款。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '酒气带驾驶处罚新设',
    'summary': '自行车酒气带驾驶新设3年以下有期徒刑或50万日元以下罚款。在原有醉酒驾驶基础上，酒气带也成为处罚对象。',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': '全年龄头盔佩戴努力义务化',
    'summary': '2023年4月1日起所有自行车使用者佩戴头盔成为努力义务。虽无罚则，但可大幅降低头部致命伤风险。',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _vi = [
  {
    'title': 'Bắt đầu hệ thống "Vé xanh" cho xe đạp',
    'summary': 'Từ 1/11/2024, hệ thống vé phạt giao thông (vé xanh) áp dụng cho xe đạp. Từ 16 tuổi: vượt đèn đỏ 6.000 yên, không dừng 5.000 yên.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Tăng cường xử phạt sử dụng điện thoại',
    'summary': 'Sử dụng điện thoại khi đi xe đạp: phạt tù dưới 6 tháng hoặc phạt tiền dưới 100.000 yên. Gây nguy hiểm: phạt tù dưới 1 năm hoặc 300.000 yên.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Quy định mới xử phạt lái xe có hơi rượu',
    'summary': 'Đi xe đạp có hơi rượu: phạt tù dưới 3 năm hoặc phạt tiền dưới 500.000 yên. Bổ sung xử phạt ngoài say rượu hiện có.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Nghĩa vụ nỗ lực đội mũ bảo hiểm mọi lứa tuổi',
    'summary': 'Từ 1/4/2023, đội mũ bảo hiểm trở thành nghĩa vụ nỗ lực cho tất cả người đi xe đạp. Không có hình phạt nhưng giảm đáng kể nguy cơ chấn thương đầu.',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _th = [
  {
    'title': 'เริ่มระบบ "ใบสั่งสีน้ำเงิน" สำหรับจักรยาน',
    'summary': 'ตั้งแต่ 1/11/2567 จักรยานเข้าสู่ระบบใบสั่งจราจร 16 ปีขึ้นไป: ฝ่าไฟแดง 6,000 เยน ไม่หยุด 5,000 เยน',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'เพิ่มโทษการใช้สมาร์ทโฟน',
    'summary': 'ใช้สมาร์ทโฟนขณะขับจักรยาน: จำคุกไม่เกิน 6 เดือนหรือปรับไม่เกิน 100,000 เยน สร้างอันตราย: จำคุกไม่เกิน 1 ปีหรือ 300,000 เยน',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'บทลงโทษใหม่สำหรับขับขี่ขณะมีแอลกอฮอล์',
    'summary': 'ขับจักรยานขณะมีแอลกอฮอล์: จำคุกไม่เกิน 3 ปีหรือปรับไม่เกิน 500,000 เยน เพิ่มจากโทษเมาสุราเดิม',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'หน้าที่ความพยายามสวมหมวกกันน็อคทุกวัย',
    'summary': 'ตั้งแต่ 1/4/2566 การสวมหมวกกันน็อคเป็นหน้าที่ความพยายามสำหรับทุกคน ไม่มีโทษแต่ลดความเสี่ยงบาดเจ็บศีรษะอย่างมาก',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];

const _fil = [
  {
    'title': 'Nagsimula ang "Blue Ticket" System para sa Bisikleta',
    'summary': 'Mula Nov 1, 2024, traffic violation tickets (blue tickets) para sa bisikleta. 16+ taon: red light 6,000 yen, failure to stop 5,000 yen.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Mas Maigting na Parusa sa Paggamit ng Smartphone',
    'summary': 'Paggamit ng smartphone habang nagbibisikleta: hanggang 6 buwan pagkakulong o 100,000 yen multa. Kung may panganib: 1 taon o 300,000 yen.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Bagong Parusa para sa Tipsy Driving',
    'summary': 'Pagbibisikleta na may alkohol: hanggang 3 taon pagkakulong o 500,000 yen multa. Karagdagan sa umiiral na drunk driving penalties.',
    'date': '2024-11-01',
    'category': 'new_law',
  },
  {
    'title': 'Helmet Effort Obligation para sa Lahat ng Edad',
    'summary': 'Mula Apr 1, 2023, pagsusuot ng helmet ay effort obligation para sa lahat ng cyclist. Walang parusa pero malaking bawas sa panganib ng head injury.',
    'date': '2023-04-01',
    'category': 'equipment',
  },
];
