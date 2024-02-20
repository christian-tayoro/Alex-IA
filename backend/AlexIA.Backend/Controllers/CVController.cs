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
        private readonly string CosmosDBAccountUri = "https://canctr-dev-alexia-dbacc.documents.azure.com:443/";
        private readonly string CosmosDBAccountPrimaryKey = "A7IRAusDlJ741D0rIHvBw0Yp6KlAtWJ2DaNOmhi5LWWX1bEkRJhAfL2uVPVy4AxSFPIoL3FLl3s3ACDbOg3OHg==";
        private readonly string CosmosDbName = "alexia-db";
        private readonly string CosmosDbContainerName = "cv";
        private readonly FileService _fileService;

        public CVController(FileService fileService)
        {
            _fileService = fileService;
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
        public async Task<IActionResult> Upload([FromForm]IFormFile file)
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
