import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

// Request Models
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String name,
    required String email,
    required String password,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refresh_token,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String name,
    required String email,
    required String password,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
}

@freezed
class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    String? name,
    String? email,
    bool? is_active,
  }) = _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);
}

// Response Models
@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required String id,
    required String email,
    required String name,
    required bool is_active,
    required DateTime created_at,
    required DateTime updated_at,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String message,
    required LoginUserData user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginUserData with _$LoginUserData {
  const factory LoginUserData({
    required String access_token,
    required String refresh_token,
  }) = _LoginUserData;

  factory LoginUserData.fromJson(Map<String, dynamic> json) =>
      _$LoginUserDataFromJson(json);
}

@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String message,
    required UserResponse user,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

@freezed
class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    required String message,
    required LoginUserData user,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@freezed
class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required String message,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}

@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String error,
    required int code,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

@freezed
class UsersListResponse with _$UsersListResponse {
  const factory UsersListResponse({
    required List<UserResponse> users,
    required int total,
    required int page,
    required int limit,
  }) = _UsersListResponse;

  factory UsersListResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersListResponseFromJson(json);
}

@freezed
class HealthResponse with _$HealthResponse {
  const factory HealthResponse({
    required String status,
    required String service,
  }) = _HealthResponse;

  factory HealthResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthResponseFromJson(json);
} 