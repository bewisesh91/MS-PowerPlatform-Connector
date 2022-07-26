using Newtonsoft.Json;

namespace OCAProject.Models
{
    public class ResponseMessage
    {
        [JsonProperty("response_message")]
        public string Message {get; set;}
    }
}
