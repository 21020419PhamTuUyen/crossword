class BlocUtils {
  static String getMessageError(dynamic exception) {
    return exception?.toString() ?? "error.common";
  }
}
