// Uji repository auth terhadap respons backend palsu.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailboxh/core/error/app_exception.dart';
import 'package:mailboxh/core/services/api_client.dart';
import 'package:mailboxh/features/auth/data/auth_repository.dart';
import 'package:mailboxh/features/auth/domain/auth_models.dart';
import 'package:mailboxh/features/auth/domain/auth_repository.dart';

import '../../helpers/fakes.dart';

Map<String, dynamic> _loginBody() => <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'token': 'token-abc',
        'user': <String, dynamic>{
          'id': 7,
          'name': 'Rama',
          'email': 'rama@example.com',
          'role': 'user',
        },
      },
    };

AuthRepositoryImpl _repository(FakeTokenStorage storage, Dio dio) {
  return AuthRepositoryImpl(
    apiClient: ApiClient(tokenStorage: storage, dio: dio),
    tokenStorage: storage,
  );
}

void main() {
  late FakeTokenStorage storage;

  setUp(() {
    storage = FakeTokenStorage();
  });

  test('login mengembalikan profil user dan menyimpan token', () async {
    final Dio dio = Dio()
      ..httpClientAdapter = FakeHttpClientAdapter(_loginBody());
    final AuthRepository repository = _repository(storage, dio);

    final AuthUser user =
        await repository.login(email: 'rama@example.com', password: 'rahasia123');

    expect(user.id, 7);
    expect(user.name, 'Rama');
    expect(user.email, 'rama@example.com');
    expect(storage.token, 'token-abc');
  });

  test('login gagal 401 melempar UnauthorizedException', () async {
    final Dio dio = Dio()
      ..httpClientAdapter = FakeHttpClientAdapter(
        <String, dynamic>{'message': 'Kredensial salah'},
        statusCode: 401,
      );
    final AuthRepository repository = _repository(storage, dio);

    expect(
      () => repository.login(email: 'rama@example.com', password: 'salah'),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(storage.token, isNull);
  });

  test('fetchCurrentUser mengembalikan profil dari token sesi', () async {
    storage.token = 'token-abc';
    final Dio dio = Dio()
      ..httpClientAdapter = FakeHttpClientAdapter(<String, dynamic>{
        'success': true,
        'data': <String, dynamic>{
          'id': 7,
          'name': 'Rama',
          'email': 'rama@example.com',
          'role': 'admin',
        },
      });
    final AuthRepository repository = _repository(storage, dio);

    final AuthUser user = await repository.fetchCurrentUser();

    expect(user.role, 'admin');
    expect(user.isAdmin, isTrue);
  });

  test('logout menghapus token walau revoke di backend gagal', () async {
    storage.token = 'token-abc';
    final Dio dio = Dio()
      ..httpClientAdapter = FakeHttpClientAdapter(
        <String, dynamic>{'message': 'Server sedang sibuk'},
        statusCode: 500,
      );
    final AuthRepository repository = _repository(storage, dio);

    await repository.logout();

    expect(storage.token, isNull);
  });
}
