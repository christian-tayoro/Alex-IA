using AlexIA.Frontend.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace AlexIA.Frontend.Pages
{
    public class IndexModel : PageModel
    {
        private readonly string apiUri = Environment.GetEnvironmentVariable("AzureAd:ApiUriBaseAdress");
        private readonly ILogger<IndexModel> _logger;
        public List<BlobDto> cvList = new List<BlobDto>();

        public IndexModel(ILogger<IndexModel> logger)
        {
            _logger = logger;
        }

        public async Task OnGetAsync()
        {
            using (var httpClient = new HttpClient())
            {
                httpClient.BaseAddress = new Uri(apiUri);
                using (var response = await httpClient.GetAsync("/api/CV/ListAllBlobs"))
                {
                    string apiResponse = await response.Content.ReadAsStringAsync();
                    this.cvList = JsonConvert.DeserializeObject<List<BlobDto>>(apiResponse);
                }
            }
        }

    }
}
