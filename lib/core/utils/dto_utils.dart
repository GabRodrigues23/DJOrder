abstract final class DtoUtils {
  static T get<T>(dynamic value, {required T defaultValue}) {
    final bool isSameType = value != null && value is T;
    if (isSameType) return value;
    return defaultValue;
  }
}
