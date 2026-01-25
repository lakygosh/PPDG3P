using System.Text.Json;
using Microsoft.Data.SqlClient;
using PPDG3P.Api.Models;

namespace PPDG3P.Api.Middleware;

public class SqlExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<SqlExceptionMiddleware> _logger;

    public SqlExceptionMiddleware(RequestDelegate next, ILogger<SqlExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "SQL Exception occurred");
            await HandleSqlExceptionAsync(context, ex);
        }
        catch (ArgumentException ex)
        {
            _logger.LogWarning(ex, "Argument exception occurred");
            await HandleArgumentExceptionAsync(context, ex);
        }
    }

    private static async Task HandleSqlExceptionAsync(HttpContext context, SqlException exception)
    {
        context.Response.ContentType = "application/json";
        context.Response.StatusCode = StatusCodes.Status400BadRequest;

        var errors = new List<SqlErrorResponse>();

        foreach (SqlError error in exception.Errors)
        {
            errors.Add(new SqlErrorResponse
            {
                ErrorNumber = error.Number,
                Message = error.Message,
                Procedure = string.IsNullOrEmpty(error.Procedure) ? null : error.Procedure,
                LineNumber = error.LineNumber,
                State = error.State,
                Class = error.Class,
                Server = error.Server
            });
        }

        var response = new
        {
            Type = "SqlException",
            Title = "Database Error",
            Status = 400,
            Errors = errors
        };

        var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
        await context.Response.WriteAsync(JsonSerializer.Serialize(response, options));
    }

    private static async Task HandleArgumentExceptionAsync(HttpContext context, ArgumentException exception)
    {
        context.Response.ContentType = "application/json";
        context.Response.StatusCode = StatusCodes.Status400BadRequest;

        var response = new
        {
            Type = "ArgumentException",
            Title = "Invalid Request",
            Status = 400,
            Detail = exception.Message
        };

        var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
        await context.Response.WriteAsync(JsonSerializer.Serialize(response, options));
    }
}
