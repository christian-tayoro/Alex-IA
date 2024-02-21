using AlexIA.Backend.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

namespace AlexIA.Backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class CVController : ControllerBase
    {
        private readonly string CosmosDBAccountUri;
        private readonly string CosmosDBAccountPrimaryKey;
        private readonly string CosmosDbName;
        private readonly string CosmosDbContainerName;
        public IConfiguration Configuration { get; }
        private readonly FileService _fileService;

        public CVController(FileService fileService, IConfiguration configuration)
        {
            _fileService = fileService;
            Configuration = configuration;
            CosmosDBAccountUri = Configuration.GetValue<string>("AzureAd:CosmosDBAccountUri");
            CosmosDBAccountPrimaryKey = Configuration.GetValue<string>("AzureAd:CosmosDBAccountPrimaryKey");
            CosmosDbName = Configuration.GetValue<string>("AzureAd:CosmosDbName");
            CosmosDbContainerName = Configuration.GetValue<string>("AzureAd:CosmosDbContainerName");
        }

        [HttpPost]
        public async Task<IActionResult> AddCV(CVModel newCV)
        {
            try
            {
                var container = ContainerClient();
                var response = await container.CreateItemAsync(newCV, new PartitionKey(newCV.id));
                List<CVModel> cvs = new List<CVModel>();

                return Ok(cvs);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ListAllBlobs()
        {
            var result = await _fileService.ListAsync();
            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Upload(IFormFile file)
        {
            var result = await _fileService.UploadAsync(file);
            return Ok(result);
        }

        [HttpGet]
        [Route("filename")]
        public async Task<IActionResult> Download(string filename)
        {
            var result = await _fileService.DownloadAsync(filename);
            return File(result.Content, result.ContentType, result.Name);
        }

        [HttpDelete]
        [Route("filename")]
        public async Task<IActionResult> Delete(string filename)
        {
            var result = await _fileService.DeleteAsync(filename);
            return Ok(result);
        }

        #region Fonction Annexes
        private Container ContainerClient()
        {

            CosmosClient cosmosDbClient = new CosmosClient(CosmosDBAccountUri, CosmosDBAccountPrimaryKey);
            Container containerClient = cosmosDbClient.GetContainer(CosmosDbName, CosmosDbContainerName);
            return containerClient;
        }

        #endregion

    }
}
