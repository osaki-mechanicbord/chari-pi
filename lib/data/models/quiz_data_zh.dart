import 'quiz_data.dart';

class QuizDataZh {
  static const List<QuizQuestion> questions = [
    // ===== easy =====
    QuizQuestion(question: '自行车应该在道路的哪一侧行驶？', options: ['右侧', '左侧', '哪边都可以', '中间'], correctIndex: 1, explanation: '自行车是车辆，必须在道路左侧行驶（道路交通法第17条）。', difficulty: 'easy', category: 'basic'),
    QuizQuestion(question: '在有停车标志的十字路口，自行车应该怎么做？', options: ['减速通过', '完全停车后确认安全', '按铃通过', '没有行人就可以通过'], correctIndex: 1, explanation: '在停车标志处，必须完全停车并确认左右安全后再通行。', difficulty: 'easy', category: 'intersection'),
    QuizQuestion(question: '夜间骑自行车必须配备什么？', options: ['头盔', '前灯和尾灯（反光板）', '反光背心', '车铃'], correctIndex: 1, explanation: '夜间必须开启前灯并安装尾灯或反光板（道路交通法第52条）。', difficulty: 'easy', category: 'equipment'),
    QuizQuestion(question: '在没有信号灯的人行横道上有行人时，自行车应该？', options: ['直接通过', '按铃通过', '停车让行人先行', '让行人让路'], correctIndex: 2, explanation: '人行横道上行人优先。有行人时必须停车。', difficulty: 'easy', category: 'intersection'),
    QuizQuestion(question: '骑自行车撑伞是否允许？', options: ['下雨天允许', '多数都道府县禁止', '风不大就允许', '被允许'], correctIndex: 1, explanation: '撑伞骑行是单手驾驶很危险。多数都道府县条例禁止。请穿雨衣。', difficulty: 'easy', category: 'prohibition'),
    QuizQuestion(question: '自行车在道路交通法中如何分类？', options: ['行人', '轻车辆', '机动自行车', '特殊车辆'], correctIndex: 1, explanation: '自行车在道路交通法中被分类为"轻车辆"。', difficulty: 'easy', category: 'basic'),
    QuizQuestion(question: '购买自行车后需要防犯登记吗？', options: ['自愿', '法律规定必须', '只有贵重自行车需要', '被盗后再登记就行'], correctIndex: 1, explanation: '自行车防犯登记是法律规定的义务。', difficulty: 'easy', category: 'registration'),
    QuizQuestion(question: '骑自行车走车道时正确的是？', options: ['靠右侧人行道', '车道中央', '车道左侧边缘', '哪里都可以'], correctIndex: 2, explanation: '自行车必须在车道左侧边缘行驶。', difficulty: 'easy', category: 'basic'),
    // ===== medium =====
    QuizQuestion(question: '自行车可以在人行道上行驶的条件是？', options: ['随时可以', '仅限有"自行车可通行"标志等情况', '没有行人时', '仅限雨天'], correctIndex: 1, explanation: '人行道原则禁止行驶。仅在有标志、13岁以下/70岁以上、车道危险时允许。', difficulty: 'medium', category: 'basic'),
    QuizQuestion(question: '骑自行车戴耳机是否允许？', options: ['允许', '单耳允许', '多数都道府县禁止', '音量小就允许'], correctIndex: 2, explanation: '多数都道府县条例禁止因佩戴耳机等导致无法听到安全驾驶所需声音的驾驶行为。', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '自行车二人骑行被允许的条件是？', options: ['短距离就允许', '在儿童座椅上载6岁以下儿童', '成人之间也允许', '完全禁止'], correctIndex: 1, explanation: '仅限16岁以上驾驶者在儿童座椅上载1名6岁以下幼儿。', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '2023年4月起自行车头盔佩戴是？', options: ['义务化', '努力义务化', '仍为推荐', '仅13岁以下义务'], correctIndex: 1, explanation: '自2023年4月1日起，所有自行车使用者佩戴头盔成为努力义务。', difficulty: 'medium', category: 'equipment'),
    QuizQuestion(question: '骑自行车右转时正确的方法是？', options: ['直接右转', '两阶段右转', '按行人信号横穿', '打手势就可以直接右转'], correctIndex: 1, explanation: '自行车在十字路口右转时需要两阶段右转。', difficulty: 'medium', category: 'intersection'),
    QuizQuestion(question: '自行车并排行驶是？', options: ['随时可以', '仅限有"并行可"标志的地方', '2辆以内可以', '仅禁止3辆以上'], correctIndex: 1, explanation: '自行车并排行驶原则禁止。仅在有标志时允许2辆并行。', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '雨天自行车刹车制动距离会怎样？', options: ['不变', '约增加2倍以上', '稍微缩短', '与天气无关'], correctIndex: 1, explanation: '雨天刹车效果变差，制动距离可能增加2倍以上。', difficulty: 'medium', category: 'safety'),
    QuizQuestion(question: '自行车前灯所需亮度标准是？', options: ['没有特别标准', '能确认10m前方的亮度', '能确认50m前方的亮度', '能确认100m前方的亮度'], correctIndex: 1, explanation: '前灯需要白色或淡黄色，能确认10m前方障碍物的亮度。', difficulty: 'medium', category: 'equipment'),
    QuizQuestion(question: '没有"自行车除外"辅助标志的单行道上，自行车可以？', options: ['可以逆行', '逆行违反道路交通法', '慢行就可以逆行', '自行车可以忽略所有单行道'], correctIndex: 1, explanation: '没有"自行车除外"辅助标志时，自行车也必须遵守单行道规定。', difficulty: 'medium', category: 'road'),
    // ===== hard =====
    QuizQuestion(question: '自行车醉酒驾驶的处罚是？', options: ['无处罚', '5万日元以下罚款', '5年以下有期徒刑或100万日元以下罚款', '仅警告'], correctIndex: 2, explanation: '自行车醉酒驾驶处5年以下有期徒刑或100万日元以下罚款。', difficulty: 'hard', category: 'prohibition'),
    QuizQuestion(question: '2024年11月起骑车看手机的处罚是？', options: ['仅警告', '反则金5,000日元', '6个月以下有期徒刑或10万日元以下罚款', '1万日元以下罚款'], correctIndex: 2, explanation: '2024年11月法律修改后，骑车看手机处6个月以下有期徒刑或10万日元以下罚款。', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '2024年11月起"蓝色罚单"闯红灯的反则金是多少？', options: ['3,000日元', '5,000日元', '6,000日元', '10,000日元'], correctIndex: 2, explanation: '蓝色罚单制度中闯红灯反则金为6,000日元。16岁以上适用。', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '自行车事故损害赔偿，过去判例最高金额约为多少？', options: ['约500万日元', '约1,000万日元', '约5,000万日元', '约9,500万日元'], correctIndex: 3, explanation: '2013年神户地方法院判决约9,500万日元的赔偿命令。', difficulty: 'hard', category: 'insurance'),
    QuizQuestion(question: '3年内被查处2次以上危险行为会怎样？', options: ['仅罚款', '吊销驾照', '必须参加自行车驾驶员讲习', '禁止使用自行车'], correctIndex: 2, explanation: '3年内2次以上危险行为被查处时，必须参加自行车驾驶员讲习（费用6,000日元，3小时）。', difficulty: 'hard', category: 'basic'),
    QuizQuestion(question: '在人行道行驶时正确的规则是？', options: ['不妨碍行人就可以在任何地方行驶', '在人行道靠车道一侧缓行，不妨碍行人通行', '按铃让行人让路', '在人行道中央行驶'], correctIndex: 1, explanation: '在人行道行驶时必须靠车道一侧缓行，不得妨碍行人通行。', difficulty: 'hard', category: 'basic'),
    QuizQuestion(question: '2024年11月新设的"酒气带驾驶"处罚是？', options: ['反则金5,000日元', '1年以下有期徒刑或30万日元以下罚款', '3年以下有期徒刑或50万日元以下罚款', '5年以下有期徒刑或100万日元以下罚款'], correctIndex: 2, explanation: '新设的酒气带驾驶处罚为3年以下有期徒刑或50万日元以下罚款。', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '用手势信号示意右转的时机是？', options: ['右转前一刻', '右转前10m', '右转前30m', '右转前50m'], correctIndex: 2, explanation: '左右转信号需在30m前发出。变更车道需在3秒前发出。', difficulty: 'hard', category: 'safety'),
    QuizQuestion(question: '在自行车保险义务化地区未投保时？', options: ['有处罚', '目前无处罚但违反义务', '没问题', '没收自行车'], correctIndex: 1, explanation: '许多地方自治体义务化，但目前未投保没有处罚规定。但属于义务违反。', difficulty: 'hard', category: 'insurance'),
    // ===== 规则手册追加问题 =====
    QuizQuestion(question: '有自行车道的道路上，自行车应该在哪里骑行？', options: ['车道左侧边缘', '自行车道', '人行道', '哪里都可以'], correctIndex: 1, explanation: '有自行车道时，自行车有义务在该自行车道骑行（道路交通法第63条之3）。', difficulty: 'medium', category: 'road'),
    QuizQuestion(question: '路面上画的"矢羽根标记（自行车导航标记）"有法律强制力吗？', options: ['有（骑行义务）', '没有（骑行规则的视觉辅助）', '是罚款对象', '与标志具有相同法律效力'], correctIndex: 1, explanation: '矢羽根标记本身没有法律强制力，但起到自行车应在车道左侧骑行的视觉辅助作用。', difficulty: 'medium', category: 'road'),
    QuizQuestion(question: '防止大型车辆"内轮差"卷入事故最重要的是什么？', options: ['在大型车辆右侧骑行', '在路口不要站在大型车辆左侧', '比大型车辆先通过路口', '按铃提醒注意'], correctIndex: 1, explanation: '大型车辆内轮差大，左转时有卷入左侧自行车的危险。在路口不站在大型车辆左侧最为重要。', difficulty: 'hard', category: 'safety'),
    QuizQuestion(question: '发生自行车事故时最先应该做什么？', options: ['打电话给保险公司', '在安全地方停车防止二次事故', '询问对方联系方式', '离开现场'], correctIndex: 1, explanation: '事故时首先在安全地方停车防止二次事故，然后救护伤者，再通报警察（110）。', difficulty: 'medium', category: 'safety'),
    QuizQuestion(question: '被命令参加自行车驾驶员讲习的条件是？', options: ['1次违规就被命令', '3年内2次以上危险行为', '5年内3次以上违规', '每年1次必修'], correctIndex: 1, explanation: '3年内因2次以上危险行为被开罚单时，将被命令参加自行车驾驶员讲习（3小时·6,150日元）。', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '大阪府自行车条例中被义务化的是什么？', options: ['佩戴头盔', '加入自行车保险', '取得自行车驾照', '每年1次安全讲习'], correctIndex: 1, explanation: '大阪府2016年4月施行的条例规定，加入自行车损害赔偿保险等是义务。', difficulty: 'hard', category: 'insurance'),
  ];
}
