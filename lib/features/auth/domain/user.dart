/// Auth Feature Domain: User entity representing the authenticated user.
class User {
  const User({required this.uid, required this.email});
  final String uid;
  final String email;
}
