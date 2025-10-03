using Microsoft.AspNetCore.Mvc;

namespace SimpleWebApi.Controllers;

[ApiController]
[Route("[controller]")]
public class HelloController : ControllerBase
{
    private readonly ILogger<HelloController> _logger;

    public HelloController(ILogger<HelloController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IActionResult Get()
    {
        _logger.LogInformation("Handling GET /hello");
        return Ok("Hello from ECS Fargate!");
    }
}
