using System;
using LoginSystem.DTO;
using LoginSystem.Models;
using LoginSystem.Services;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using MongoDB.Bson;
using MongoDB.Driver;

namespace LoginSystem.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IMongoDbService _mongoDbService;
        private readonly TokenService _tokenService;
        private readonly ISendEmail _sendEmail;
        private readonly IMemoryCache _cache;
        public UserController(IMongoDbService mongoDbService, TokenService tokenService, ISendEmail sendEmail, IMemoryCache cache)
        {
            _mongoDbService = mongoDbService;
            _tokenService = tokenService;
            _sendEmail = sendEmail;
            _cache = cache;

        }




        [HttpPost("verificationcode")]
        public async Task<IResult> SendVerificationCode([FromBody] string email)
        {
            if (string.IsNullOrWhiteSpace(email.Trim()))
                return Results.BadRequest("Email cannot be empty");
            if (!email.Trim().EndsWith("@gmail.com"))
            {
                return Results.BadRequest("email must end with '@gmail.com'");
            }
            Random random = new();
            string verifyCode = random.Next(100000, 999999).ToString();

            var cacheEntryOptions = new MemoryCacheEntryOptions()
            .SetAbsoluteExpiration(TimeSpan.FromMinutes(5));

            _cache.Set(email.Trim(), verifyCode, cacheEntryOptions);

            await _sendEmail.SendVerificationCode(
                email.Trim(),
                "verification code",
                "Your verify code is: " + verifyCode
            );


            return Results.Ok("Verification code sent successfully");
        }




        [HttpPost("signup")]
        public async Task<IResult> SignUp([FromBody] RegisterDTO info)
        {
            if (info.Name.Trim() == "" || info.Email.Trim() == "" || info.Password.Trim() == "" || info.ConfirmPassword.Trim() == "" || info.VerifyCode.Trim() == "")
            {
                return Results.BadRequest("give all information correctly!!!");
            }
            if (info.Password.Trim().Length < 8)
            {
                return Results.BadRequest("password length should be 8 and more!!!");
            }

            if (info.Password.Trim() != info.ConfirmPassword.Trim())
            {
                return Results.BadRequest("Password and Conform password should match!!!");
            }

            if (!info.Email.Trim().EndsWith("@gmail.com"))
            {
                return Results.BadRequest("invalied email (should end with '@gmail.com')");
            }
            if (!_cache.TryGetValue<string>(info.Email.Trim(), out var cachedCode))
            {
                return Results.BadRequest("Verify code is incorrect or expired");
            }

            if (cachedCode != info.VerifyCode.Trim())
            {
                return Results.BadRequest("Verify code is incorrect");
            }

            // Optionally remove code after successful use:
            _cache.Remove(info.Email.Trim());
            UserModel u = new()
            {
                Name = info.Name,
                Email = info.Email,
                Password = info.Password,
                ConfirmPassword = info.ConfirmPassword,
            };
            try
            {
                User user = await _mongoDbService.AddUser(u);
                string token = _tokenService.createToken(user.Id.ToString());
                var result = new
                {
                    id = user.Id.ToString(),
                    u = user,
                    t = token
                };
                return Results.Ok(result);
            }
            catch (MongoWriteException ex) when (ex.WriteError.Category == ServerErrorCategory.DuplicateKey)
            {
                return Results.BadRequest("Email already exists");
            }

        }








        [HttpPost("login")]
        public async Task<IResult> Login([FromBody] LoginDTO login)
        {
            if (!login.Email.Trim().EndsWith("@gmail.com"))
            {
                return Results.BadRequest("invalied email (should end with '@gmail.com')");
            }
            if (login.Password.Trim().Length < 8)
            {
                return Results.BadRequest("password length should be 8 and more!!!");
            }
            try
            {
                User? user = await _mongoDbService.GetUser(login.Email.Trim(), login.Password.Trim());
                if (user is null)
                {
                    return Results.BadRequest("User not found");
                }
                string token = _tokenService.createToken(user.Id.ToString());
                var result = new
                {
                    id = user.Id.ToString(),
                    u = user,
                    t = token
                };
                return Results.Ok(result);
            }
            catch (MongoWriteException)
            {
                return Results.BadRequest("Something went wrong!!!");
            }

        }







        [HttpPut("resetpassword")]
        [Authorize]
        public async Task<IResult> ResetPassword([FromBody] ResetPasswordDTO resetPassword)
        {

            if (resetPassword.Password.Trim().Length < 8)
            {
                return Results.BadRequest("password length should be 8 and more!!!");
            }
            if (resetPassword.Password.Trim() != resetPassword.ConfirmPassword.Trim())
            {
                return Results.BadRequest("password and confirm password must match!!!");
            }

            try
            {

                await _mongoDbService.ResetPassword(ObjectId.Parse(resetPassword.Id.Trim()), resetPassword.Password.Trim());
                return Results.Ok("password change successfully");
            }
            catch (MongoWriteException)
            {
                return Results.BadRequest("Something went wrong!!!");
            }
        }







        [HttpPut("forgetpassword")]
        public async Task<IResult> ForgetPassword([FromBody] ForgetPasswordDTO forgetPasswordDTO)
        {
            if (forgetPasswordDTO.Password.Trim().Length < 8)
            {
                return Results.BadRequest("Password length must be greater than 7");
            }
            if (forgetPasswordDTO.Password.Trim() != forgetPasswordDTO.ConfirmPassword.Trim())
            {
                return Results.BadRequest("Password and confirm password must be the same!!");
            }
            if (!forgetPasswordDTO.Email.Trim().EndsWith("@gmail.com"))
            {
                return Results.BadRequest("email must end with '@gmail.com'");
            }
            if (!_cache.TryGetValue<string>(forgetPasswordDTO.Email.Trim(), out var cachedCode))
            {
                return Results.BadRequest("Verify code is incorrect or expired");
            }
            if (forgetPasswordDTO.VerifyCode.Trim() != cachedCode)
            {
                return Results.BadRequest("Verify code is incorrect!!");
            }
            try
            {
                await _mongoDbService.forgetPassword(forgetPasswordDTO.Email.Trim(), forgetPasswordDTO.Password.Trim());
                _cache.Remove(forgetPasswordDTO.Email.Trim());
                return Results.Ok("password changed successfully");
            }
            catch (MongoWriteException)
            {
                return Results.BadRequest("Something went wrong!!!");
            }

        }







    }
}
