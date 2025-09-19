import 'package:dartz/dartz.dart';
import '../services/api_service.dart';
import '../services/failure.dart';
import '../models/profile_model.dart';

class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final response = await api.get("profile");
      return Right(ProfileModel());
    } catch (e) {
      return Left(e is Failure ? e : Failure(e.toString()));
    }
  }

  Future<Either<Failure, ProfileModel>> socialAuth({
    required String provider,
    required String token,
  }) async {
    try {
      final response = await api.post("auth/social", data: {
        "provider": provider,
        "token": token,
      });
            return Right(ProfileModel());

    } catch (e) {
      return Left(e is Failure ? e : Failure(e.toString()));
    }
  }
}