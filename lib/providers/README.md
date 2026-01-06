# Providers Directory

이 디렉토리는 Riverpod provider들을 관리합니다.

## 구조

```
providers/
├── gift_input/          # 선물 입력 관련 상태
│   ├── target_provider.dart
│   ├── event_provider.dart
│   ├── persona_provider.dart
│   ├── budget_provider.dart
│   └── option_provider.dart
├── results/             # 결과 관련 상태
│   └── recommendation_provider.dart
└── settings/            # 설정 관련 상태
    └── app_settings_provider.dart
```

## 사용 예제

### Provider 생성
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider 예제 (간단한 상태)
final counterProvider = StateProvider<int>((ref) => 0);

// Provider 예제 (읽기 전용)
final messageProvider = Provider<String>((ref) => 'Hello, Riverpod!');

// StateNotifierProvider 예제 (복잡한 상태)
class GiftInputNotifier extends StateNotifier<GiftInputState> {
  GiftInputNotifier() : super(GiftInputState.initial());

  void updateTarget(String relation, String gender, String ageGroup) {
    state = state.copyWith(
      relation: relation,
      gender: gender,
      ageGroup: ageGroup,
    );
  }
}

final giftInputProvider = StateNotifierProvider<GiftInputNotifier, GiftInputState>(
  (ref) => GiftInputNotifier(),
);
```

### Widget에서 사용
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidget 사용
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Text('Count: $count');
  }
}

// Consumer 사용
Consumer(
  builder: (context, ref, child) {
    final message = ref.watch(messageProvider);
    return Text(message);
  },
)

// ref.read() - 이벤트 핸들러에서
ElevatedButton(
  onPressed: () {
    ref.read(counterProvider.notifier).state++;
  },
  child: Text('Increment'),
)
```

## 참고 자료
- [Riverpod 공식 문서](https://riverpod.dev)
- [Flutter Riverpod 가이드](https://docs-v2.riverpod.dev/docs/getting_started)
