using Newtonsoft.Json;

namespace OCA.Models
{
    public class ResponseMessage
    {
        [JsonProperty("response_message")]
        public string Message {get; set;}
    }
}