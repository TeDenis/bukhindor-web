import '../../features/auth/domain/entities/user_entity.dart';
import '../models/api_models.dart';

class UserMapper {
  static UserEntity fromApiResponse(UserResponse response) {
    return UserEntity(
      id: response.id,
      email: response.email,
      name: response.name,
      isActive: response.is_active,
      emailVerified: response
          .is_active, // Предполагаем, что активные пользователи верифицированы
      createdAt: response.created_at,
      updatedAt: response.updated_at,
    );
  }

  static UserResponse toApiResponse(UserEntity entity) {
    return UserResponse(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      is_active: entity.isActive,
      created_at: entity.createdAt,
      updated_at: entity.updatedAt,
    );
  }
}
