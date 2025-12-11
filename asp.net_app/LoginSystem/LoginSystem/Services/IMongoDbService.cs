using LoginSystem.Models;
using MongoDB.Bson;

namespace LoginSystem.Services
{
    public interface IMongoDbService
    {
        public Task<User> AddUser(UserModel user);
        public Task<User?> GetUser(string email, string password);
        public Task ResetPassword(ObjectId id, string password);

    }
}
