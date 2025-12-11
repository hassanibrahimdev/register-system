using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LoginSystem.Models
{
    public class User
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public ObjectId Id { get; set; }
        public  string Name { get; set; }

        public  string Email { get; set; }
        public  string Password { get; set; }
    }
}
