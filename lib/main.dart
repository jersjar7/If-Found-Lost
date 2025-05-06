import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'package:if_found_lost/core/config/firebase_config.dart';

// Domain
import 'package:if_found_lost/domain/usecases/auth_usecases.dart';
import 'package:if_found_lost/domain/usecases/user_usecases.dart';
import 'package:if_found_lost/domain/usecases/qr_code_usecases.dart';

// Data
import 'package:if_found_lost/data/datasources/remote/auth_remote_datasource.dart';
import 'package:if_found_lost/data/datasources/remote/user_remote_datasource.dart';
import 'package:if_found_lost/data/datasources/remote/qr_code_remote_datasource.dart';
import 'package:if_found_lost/data/repositories/auth_repository_impl.dart';
import 'package:if_found_lost/data/repositories/user_repository_impl.dart';
import 'package:if_found_lost/data/repositories/qr_code_repository_impl.dart';

// Presentation
import 'package:if_found_lost/presentation/bloc/auth/auth_bloc.dart';
import 'package:if_found_lost/presentation/bloc/user/user_bloc.dart';
import 'package:if_found_lost/presentation/bloc/qr_code/qr_code_bloc.dart';
import 'package:if_found_lost/presentation/pages/home/home_page.dart';
import 'package:if_found_lost/presentation/pages/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) => AuthBloc(
                getAuthStateUseCase: GetAuthStateUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: FirebaseAuthDatasource(),
                  ),
                ),
                getCurrentUserUseCase: GetCurrentUserUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: FirebaseAuthDatasource(),
                  ),
                ),
                signInUseCase: SignInUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: FirebaseAuthDatasource(),
                  ),
                ),
                signUpUseCase: SignUpUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: FirebaseAuthDatasource(),
                  ),
                ),
                signOutUseCase: SignOutUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: FirebaseAuthDatasource(),
                  ),
                ),
              )..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<UserBloc>(
          create:
              (context) => UserBloc(
                getUserProfileUseCase: GetUserProfileUseCase(
                  UserRepositoryImpl(
                    remoteDatasource: FirebaseUserDatasource(),
                  ),
                ),
                createUserProfileUseCase: CreateUserProfileUseCase(
                  UserRepositoryImpl(
                    remoteDatasource: FirebaseUserDatasource(),
                  ),
                ),
                updateUserProfileUseCase: UpdateUserProfileUseCase(
                  UserRepositoryImpl(
                    remoteDatasource: FirebaseUserDatasource(),
                  ),
                ),
              ),
        ),
        BlocProvider<QRCodeBloc>(
          create:
              (context) => QRCodeBloc(
                getUserQRCodesUseCase: GetUserQRCodesUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                getQRCodeByIdUseCase: GetQRCodeByIdUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                createQRCodeUseCase: CreateQRCodeUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                updateQRCodeUseCase: UpdateQRCodeUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                deleteQRCodeUseCase: DeleteQRCodeUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                generateQRCodeContentUseCase: GenerateQRCodeContentUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
                getQRCodeScanHistoryUseCase: GetQRCodeScanHistoryUseCase(
                  QRCodeRepositoryImpl(
                    remoteDatasource: FirebaseQRCodeDatasource(),
                    baseUrl: 'https://iffoundlost.app/scan/',
                  ),
                ),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'If Found Lost',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is Authenticated) {
              return const HomePage();
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
