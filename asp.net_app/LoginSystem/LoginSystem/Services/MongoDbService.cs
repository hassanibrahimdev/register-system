using LoginSystem.Models;
using Microsoft.AspNetCore.Identity;
using MongoDB.Bson;
using MongoDB.Driver;

namespace LoginSystem.Services
{

    public class MongoDbService : IMongoDbService

    {
        private readonly IMongoCollection<User> _users;
        private readonly PasswordHasher<User> _passwordHasher;
        public MongoDbService(IMongoDatabase database)
        {
            _passwordHasher = new PasswordHasher<User>();
            _users = database.GetCollection<User>("Users");
        }





        public async Task<User> AddUser(UserModel user)
        {

            User u = new()
            {
                Email = user.Email,
                Name = user.Name
            };
            u.Password = _passwordHasher.HashPassword(u, user.Password);

            await _users.InsertOneAsync(u);
            return u;
        }






        public async Task ResetPassword(ObjectId id, string password)
        {
            User user = await _users.Find(u => u.Id.Equals(id)).FirstOrDefaultAsync();
            if (user == null)
            {
                return;
            }
            user.Password = _passwordHasher.HashPassword(user, password);
            await _users.ReplaceOneAsync(u => u.Id.Equals(id), user);
        }





        public async Task<User?> GetUser(string email, string password)
        {

            User user = await _users.Find(p => p.Email.Equals(email)).FirstOrDefaultAsync();
            if (user == null)
            {
                return null;
            }
            var result = _passwordHasher.VerifyHashedPassword(user, user.Password, password);
            if (result == PasswordVerificationResult.Success)
            {
                return user;
            }
            return null;
        }

        public async Task forgetPassword(string email, string password)
        {
            User user = await _users.Find(u => u.Email.Equals(email.Trim())).FirstOrDefaultAsync();
            if (user == null)
            {
                return;
            }
            user.Password = _passwordHasher.HashPassword(user, password);
            await _users.ReplaceOneAsync(u => u.Email.Equals(email.Trim()), user);
        }
    }
}
