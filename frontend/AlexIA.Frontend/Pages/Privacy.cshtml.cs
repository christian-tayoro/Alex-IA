using AlexIA.Frontend.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace AlexIA.Frontend.Pages
{
    public class PrivacyModel : PageModel
    {
        public IConfiguration Configuration { get; }
        private readonly string apiUri;
        private readonly ILogger<PrivacyModel> _logger;
        BlobResponseDto resultat = new BlobResponseDto();

        [BindProperty]
        public BufferedSingleFileUpload FileUpload { get; set; }

        public PrivacyModel(ILogger<PrivacyModel> logger, IConfiguration configuration)
        {
            _logger = logger;
            Configuration = configuration;
            apiUri = Configuration.GetValue<string>("AzureAd:ApiUriBaseAdress");
        }

        public void OnGet()
        {
        }

        public async Task<IActionResult> OnPostAsync()
        {
            var client = new HttpClient();
            var cv = new CVModel()
            {
                id = Guid.NewGuid().ToString()
            };
            BlobResponseDto res = new BlobResponseDto();

            if (FileUpload.FormFile == null || FileUpload.FormFile.Length == 0)
            {
                return BadRequest("No file selected for upload...");
            }

            if (ModelState.IsValid)
            {
                res = await FilePostAsync();

                cv.Title = res.Blob.Name;
                cv.UrlStorage = res.Blob.Uri;

                await FileMetaDataToCosmosDB(cv);

                return RedirectToPage("Index");
            }

            return Page();
        }

        #region Fonctions annexes
        public async Task<BlobResponseDto> FilePostAsync()
        {

            string path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/Files/");

            //create folder if not exist
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            //get file extension
            FileInfo fileInfo = new FileInfo(FileUpload.FormFile.FileName);

            string fileNameWithPath = Path.Combine(path, fileInfo.Name);

            using (var fs = new FileStream(fileNameWithPath, FileMode.Create))
            {
                FileUpload.FormFile.CopyTo(fs);
            }

            using var form = new MultipartFormDataContent();
            using var fileContent = new ByteArrayContent(await System.IO.File.ReadAllBytesAsync(fileNameWithPath));
            fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse("multipart/form-data");

            // here it is important that second parameter matches with name given in API.
            form.Add(fileContent, "file", Path.GetFileName(fileNameWithPath));

            var httpClient = new HttpClient()
            {
                BaseAddress = new Uri(apiUri)
            };

            var response = await httpClient.PostAsync($"/api/CV/Upload", form);
            response.EnsureSuccessStatusCode();
            var responseContent = await response.Content.ReadAsStringAsync();
            resultat = JsonConvert.DeserializeObject<BlobResponseDto>(responseContent);

            return resultat;
        }
        
        public async Task FileMetaDataToCosmosDB(CVModel cv)
        {
            var httpClient = new HttpClient()
            {
                BaseAddress = new Uri(apiUri)
            };
            StringContent content = new StringContent(JsonConvert.SerializeObject(cv), Encoding.UTF8, "application/json");
            var response = await httpClient.PostAsync($"/api/CV/AddCV", content);
            response.EnsureSuccessStatusCode();
            var responseContent = await response.Content.ReadAsStringAsync();
        }
        
        #endregion

    }

}
