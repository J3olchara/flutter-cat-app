import '../../features/cats/data/datasources/cat_remote_datasource.dart';
import '../../features/cats/data/datasources/likes_local_datasource.dart';
import '../../features/cats/data/repositories/cat_repository_impl.dart';
import '../../features/cats/data/repositories/likes_repository_impl.dart';
import '../../features/cats/domain/repositories/cat_repository.dart';
import '../../features/cats/domain/repositories/likes_repository.dart';
import '../../features/cats/domain/usecases/get_random_cat_usecase.dart';
import '../../features/cats/domain/usecases/get_all_breeds_usecase.dart';
import '../../features/cats/domain/usecases/like_cat_usecase.dart';
import '../../features/cats/domain/usecases/get_likes_count_usecase.dart';
import '../../features/cats/domain/usecases/get_breed_details_usecase.dart';
import '../../features/cats/domain/usecases/get_breed_images_usecase.dart';
import '../../features/cats/presentation/providers/cat_provider.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../analytics/analytics_service.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  late final CatRemoteDataSource _catRemoteDataSource;
  late final LikesLocalDataSource _likesLocalDataSource;
  late final CatRepository _catRepository;
  late final LikesRepository _likesRepository;

  late final AuthRemoteDataSource _authRemoteDataSource;
  late final AuthRepository _authRepository;
  
  late final AnalyticsService _analyticsService;

  void init() {
    _catRemoteDataSource = CatRemoteDataSourceImpl();
    _likesLocalDataSource = LikesLocalDataSourceImpl();

    _catRepository = CatRepositoryImpl(_catRemoteDataSource);
    _likesRepository = LikesRepositoryImpl(_likesLocalDataSource);

    _authRemoteDataSource = AuthRemoteDataSourceImpl();
    _authRepository = AuthRepositoryImpl(_authRemoteDataSource);
    
    _analyticsService = AnalyticsService();
  }
  
  AnalyticsService get analyticsService => _analyticsService;

  CatProvider createCatProvider() {
    return CatProvider(
      getRandomCatUseCase: GetRandomCatUseCase(_catRepository),
      getAllBreedsUseCase: GetAllBreedsUseCase(_catRepository),
      likeCatUseCase: LikeCatUseCase(_likesRepository),
      getLikesCountUseCase: GetLikesCountUseCase(_likesRepository),
      getBreedDetailsUseCase: GetBreedDetailsUseCase(_catRepository),
      getBreedImagesUseCase: GetBreedImagesUseCase(_catRepository),
      analyticsService: _analyticsService,
    );
  }

  AuthProvider createAuthProvider() {
    return AuthProvider(
      signInUseCase: SignInUseCase(_authRepository),
      signUpUseCase: SignUpUseCase(_authRepository),
      signOutUseCase: SignOutUseCase(_authRepository),
      getCurrentUserUseCase: GetCurrentUserUseCase(_authRepository),
      authRepository: _authRepository,
      analyticsService: _analyticsService,
    );
  }
}
