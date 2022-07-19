using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.OpenApi.Models;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using System.Net;
using OCAProject.Services;
using OCAProject.Models;


namespace OCAProject
{
    public class PingHttpTrigger
    {   
        private readonly IMyService _service;
        public PingHttpTrigger(IMyService service)
        {
            this._service = service ?? throw new ArgumentNullException(nameof(service));
        }

        [FunctionName(nameof(PingHttpTrigger))]
        
        // OpneApi 등록 
        [OpenApiOperation(operationId: "Ping", tags: new[] { "greeting" })]
        [OpenApiSecurity(schemeName: "function_key", schemeType: SecuritySchemeType.ApiKey, Name = "x-functions-key", In = OpenApiSecurityLocationType.Header)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Description = "Name of the person to greet")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(ResponseMessage), Description = "Greeting Message")]
        
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = "ping")] HttpRequest req, ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];
            var result = this._service.GetMessage(name);

            var res = new ResponseMessage() { Message = result};

            return new OkObjectResult(res);
        }
    }
}
