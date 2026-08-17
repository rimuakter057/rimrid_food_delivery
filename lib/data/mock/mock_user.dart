import '../models/user_model.dart';

class MockUser {
  static const UserModel currentUser = UserModel(
    id: 'user_101',
    name: 'Sarah Jenkins',
    email: 'sarah.jenkins@example.com',
    phone: '+1 (555) 382-9910',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
  );
}
