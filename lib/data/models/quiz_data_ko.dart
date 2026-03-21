import 'quiz_data.dart';

class QuizDataKo {
  static const List<QuizQuestion> questions = [
    // ===== easy =====
    QuizQuestion(question: '자전거는 도로의 어느 쪽을 주행합니까?', options: ['오른쪽', '왼쪽', '어느 쪽이든', '중앙'], correctIndex: 1, explanation: '자전거는 차량이므로 도로의 좌측을 주행할 의무가 있습니다 (도로교통법 제17조).', difficulty: 'easy', category: 'basic'),
    QuizQuestion(question: '일시정지 표지판이 있는 교차로에서 자전거는 어떻게 해야 합니까?', options: ['서행하며 통과', '완전히 정지 후 안전 확인', '벨을 울리며 통과', '보행자가 없으면 통과 가능'], correctIndex: 1, explanation: '일시정지 표지판에서는 반드시 완전히 정지하고 좌우 안전을 확인한 후 통행합니다.', difficulty: 'easy', category: 'intersection'),
    QuizQuestion(question: '야간 자전거 주행에서 의무화된 것은?', options: ['헬멧', '전조등과 미등(반사판)', '반사 조끼', '벨'], correctIndex: 1, explanation: '야간에는 전조등 점등과 미등 또는 반사판 장착이 의무입니다 (도로교통법 제52조).', difficulty: 'easy', category: 'equipment'),
    QuizQuestion(question: '신호등이 없는 횡단보도에 보행자가 있을 경우, 자전거는?', options: ['그대로 통과', '벨을 울리며 통과', '일시정지하여 보행자 우선', '보행자에게 비켜달라고 요청'], correctIndex: 2, explanation: '횡단보도에서는 보행자가 최우선입니다. 보행자가 있으면 반드시 일시정지해야 합니다.', difficulty: 'easy', category: 'intersection'),
    QuizQuestion(question: '자전거의 우산 운전은?', options: ['비 오는 날이면 허용', '많은 도도부현에서 금지', '바람이 강하지 않으면 허용', '허용됨'], correctIndex: 1, explanation: '우산 운전은 한 손 운전이 되어 위험합니다. 많은 도도부현의 조례로 금지되어 있습니다.', difficulty: 'easy', category: 'prohibition'),
    QuizQuestion(question: '자전거는 도로교통법상 어떻게 분류됩니까?', options: ['보행자', '경차량', '원동기 자전거', '특수차량'], correctIndex: 1, explanation: '자전거는 도로교통법상 "경차량"으로 분류됩니다.', difficulty: 'easy', category: 'basic'),
    QuizQuestion(question: '방범등록은 자전거를 구입하면 필요합니까?', options: ['임의', '법률로 의무화', '고가 자전거만 필요', '도난 후 등록하면 됨'], correctIndex: 1, explanation: '자전거 방범등록은 법률로 의무화되어 있습니다.', difficulty: 'easy', category: 'registration'),
    QuizQuestion(question: '자전거로 차도를 달릴 때 올바른 것은?', options: ['오른쪽 보도 쪽', '차도 중앙', '차도 좌측 끝', '어디든 가능'], correctIndex: 2, explanation: '자전거는 차도의 좌측 끝을 주행할 의무가 있습니다.', difficulty: 'easy', category: 'basic'),
    // ===== medium =====
    QuizQuestion(question: '자전거가 보도를 주행할 수 있는 조건은?', options: ['언제든 가능', '"자전거 통행 가능" 표지판이 있는 경우 등에 한함', '보행자가 없을 때만', '비 오는 날만'], correctIndex: 1, explanation: '보도는 원칙적으로 주행 금지입니다. 표지판이 있는 경우, 13세 미만·70세 이상, 차도가 위험한 경우에 한합니다.', difficulty: 'medium', category: 'basic'),
    QuizQuestion(question: '자전거로 이어폰을 착용하고 주행하는 것은?', options: ['허용됨', '한쪽 귀면 허용', '많은 도도부현에서 금지', '소리가 작으면 허용'], correctIndex: 2, explanation: '많은 도도부현의 조례로 이어폰 등 사용으로 안전 운전에 필요한 소리가 들리지 않는 상태의 운전이 금지되어 있습니다.', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '자전거 2인 탑승이 허용되는 조건은?', options: ['단거리면 허용', '유아용 좌석에 6세 미만 아이를 태우는 경우', '어른끼리도 허용', '전면 금지'], correctIndex: 1, explanation: '16세 이상의 운전자가 유아용 좌석에 6세 미만 유아 1명을 태우는 경우에만 허용됩니다.', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '2023년 4월부터 자전거 헬멧 착용은?', options: ['의무화됨', '노력의무화됨', '권장 유지', '13세 미만만 의무'], correctIndex: 1, explanation: '2023년 4월 1일부터 모든 자전거 이용자에게 헬멧 착용이 노력의무화되었습니다.', difficulty: 'medium', category: 'equipment'),
    QuizQuestion(question: '자전거로 우회전할 때 올바른 방법은?', options: ['직접 우회전', '2단계 우회전', '보행자 신호에 따라 횡단', '수신호를 내면 직접 우회전 가능'], correctIndex: 1, explanation: '자전거는 교차로에서 우회전할 때 2단계 우회전이 필요합니다.', difficulty: 'medium', category: 'intersection'),
    QuizQuestion(question: '자전거 병주(나란히 달리기)는?', options: ['언제든 가능', '"병진가" 표지판이 있는 경우만 가능', '2대까지 가능', '3대 이상만 금지'], correctIndex: 1, explanation: '자전거 병주는 원칙 금지입니다. "병진가" 표지판이 있는 경우만 2대까지 허용됩니다.', difficulty: 'medium', category: 'prohibition'),
    QuizQuestion(question: '비 올 때 자전거 브레이크 제동거리는?', options: ['변화 없음', '약 2배 이상 늘어남', '약간 짧아짐', '날씨 무관'], correctIndex: 1, explanation: '비 올 때는 브레이크 효율이 떨어져 제동거리가 2배 이상 늘어날 수 있습니다.', difficulty: 'medium', category: 'safety'),
    QuizQuestion(question: '자전거 전조등에 필요한 밝기 기준은?', options: ['특별한 기준 없음', '10m 앞을 확인할 수 있는 밝기', '50m 앞을 확인할 수 있는 밝기', '100m 앞을 확인할 수 있는 밝기'], correctIndex: 1, explanation: '전조등은 백색 또는 담황색으로 10m 앞 장애물을 확인할 수 있는 밝기가 필요합니다.', difficulty: 'medium', category: 'equipment'),
    QuizQuestion(question: '"자전거 제외" 보조 표지판이 없는 일방통행로에서 자전거는?', options: ['역주행 가능', '역주행은 도로교통법 위반', '서행하면 역주행 가능', '자전거는 모든 일방통행 무시 가능'], correctIndex: 1, explanation: '"자전거 제외" 보조 표지판이 없으면 자전거도 일방통행 규제를 따라야 합니다.', difficulty: 'medium', category: 'road'),
    // ===== hard =====
    QuizQuestion(question: '자전거 음주운전의 벌칙은?', options: ['벌칙 없음', '5만엔 이하 벌금', '5년 이하 징역 또는 100만엔 이하 벌금', '주의만'], correctIndex: 2, explanation: '자전거 음주운전(주취 운전)은 5년 이하 징역 또는 100만엔 이하 벌금이 부과됩니다.', difficulty: 'hard', category: 'prohibition'),
    QuizQuestion(question: '2024년 11월부터 스마트폰 사용 운전의 벌칙은?', options: ['주의만', '반칙금 5,000엔', '6개월 이하 징역 또는 10만엔 이하 벌금', '1만엔 이하 벌금'], correctIndex: 2, explanation: '2024년 11월 법 개정으로 자전거 스마트폰 사용 운전은 6개월 이하 징역 또는 10만엔 이하 벌금입니다.', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '2024년 11월부터 도입된 "청색 딱지" 반칙금, 신호 무시는 얼마?', options: ['3,000엔', '5,000엔', '6,000엔', '10,000엔'], correctIndex: 2, explanation: '청색 딱지 제도에서 신호 무시 반칙금은 6,000엔입니다. 16세 이상 대상.', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '자전거 사고 손해배상, 과거 판례 최고액은 약 얼마?', options: ['약 500만엔', '약 1,000만엔', '약 5,000만엔', '약 9,500만엔'], correctIndex: 3, explanation: '2013년 고베 지방법원에서 약 9,500만엔의 배상 명령이 내려졌습니다.', difficulty: 'hard', category: 'insurance'),
    QuizQuestion(question: '3년 이내 2회 이상 위험행위로 적발되면?', options: ['벌금만', '면허 정지', '자전거 운전자 강습 수강 의무', '자전거 사용 금지'], correctIndex: 2, explanation: '3년 이내 2회 이상 위험행위 적발 시 자전거 운전자 강습(수수료 6,000엔, 3시간)이 의무화됩니다.', difficulty: 'hard', category: 'basic'),
    QuizQuestion(question: '보도 주행 시 올바른 규칙은?', options: ['보행자 방해가 안 되면 어디든 가능', '보도의 차도 쪽을 서행하며 보행자 통행 방해 금지', '벨을 울려 보행자를 비키게 함', '보도 중앙을 주행'], correctIndex: 1, explanation: '보도 주행 시 차도 쪽을 서행하며 보행자 통행을 방해해서는 안 됩니다.', difficulty: 'hard', category: 'basic'),
    QuizQuestion(question: '2024년 11월 신설된 "주기대 운전" 벌칙은?', options: ['반칙금 5,000엔', '1년 이하 징역 또는 30만엔 이하 벌금', '3년 이하 징역 또는 50만엔 이하 벌금', '5년 이하 징역 또는 100만엔 이하 벌금'], correctIndex: 2, explanation: '신설된 주기대 운전 벌칙은 3년 이하 징역 또는 50만엔 이하 벌금입니다.', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '수신호로 우회전 합도를 내는 타이밍은?', options: ['우회전 직전', '우회전 10m 전', '우회전 30m 전', '우회전 50m 전'], correctIndex: 2, explanation: '좌우회전 합도는 30m 전부터 내야 합니다. 진로 변경은 3초 전.', difficulty: 'hard', category: 'safety'),
    QuizQuestion(question: '자전거 보험 의무화 지역에서 미가입 시?', options: ['벌칙 있음', '현재 벌칙 없으나 의무 위반', '아무 문제 없음', '자전거 몰수'], correctIndex: 1, explanation: '많은 자치단체에서 의무화되어 있으나 현재 미가입에 대한 벌칙은 없습니다. 그러나 의무 위반입니다.', difficulty: 'hard', category: 'insurance'),
    // ===== 룰북 추가 퀴즈 =====
    QuizQuestion(question: '자전거도가 있는 도로에서 자전거는 어디를 달려야 합니까?', options: ['차도 좌측 끝', '자전거도', '보도', '어디든 가능'], correctIndex: 1, explanation: '자전거도가 있는 경우, 자전거는 그 자전거도를 주행할 의무가 있습니다 (도로교통법 제63조의3).', difficulty: 'medium', category: 'road'),
    QuizQuestion(question: '노면에 그려진 "자전거 내비 마크(화살표 마크)"는 법적 강제력이 있습니까?', options: ['있다 (주행 의무)', '없다 (주행 규칙의 시각적 보조)', '벌금 대상이 된다', '표지판과 동일한 법적 효력'], correctIndex: 1, explanation: '화살표 마크 자체에 법적 강제력은 없지만, 자전차가 차도 좌측을 달려야 한다는 것을 시각적으로 보여주는 역할을 합니다.', difficulty: 'medium', category: 'road'),
    QuizQuestion(question: '대형 차량의 "내윤차"로 인한 끌려들기 사고를 방지하기 위해 가장 중요한 것은?', options: ['대형 차량 우측을 달린다', '교차로에서 대형 차량 좌측에 서지 않는다', '대형 차량보다 먼저 교차로를 통과한다', '벨을 울려 주의를 끈다'], correctIndex: 1, explanation: '대형 차량은 내윤차가 커서 좌회전 시 좌측 자전거를 끌어들일 위험이 있습니다. 교차로에서 대형 차량 좌측에 서지 않는 것이 가장 중요합니다.', difficulty: 'hard', category: 'safety'),
    QuizQuestion(question: '자전거 사고를 당했을 때 가장 먼저 해야 할 일은?', options: ['보험회사에 전화', '안전한 장소에 정지하여 이차 사고 방지', '상대방 연락처 확인', '현장에서 떠나기'], correctIndex: 1, explanation: '사고 시에는 먼저 안전한 장소에 정지하여 이차 사고를 방지하고, 부상자 구호, 경찰 통보(110번) 순으로 대응합니다.', difficulty: 'medium', category: 'safety'),
    QuizQuestion(question: '자전거 운전자 강습이 명령되는 조건은?', options: ['1회 위반으로 명령', '3년 이내 2회 이상 위험행위', '5년 이내 3회 이상 위반', '매년 1회 수강 의무'], correctIndex: 1, explanation: '3년 이내에 2회 이상의 위험행위로 교통위반 딱지를 받은 경우, 자전거 운전자 강습(3시간·6,150엔)의 수강이 명령됩니다.', difficulty: 'hard', category: 'new_law'),
    QuizQuestion(question: '오사카부 자전거 조례에서 의무화된 것은?', options: ['헬멧 착용', '자전거 보험 가입', '자전거 면허 취득', '연 1회 안전 강습'], correctIndex: 1, explanation: '오사카부에서는 2016년 4월 시행 조례에 따라 자전거 손해배상보험 등에 가입이 의무화되어 있습니다.', difficulty: 'hard', category: 'insurance'),
  ];
}
