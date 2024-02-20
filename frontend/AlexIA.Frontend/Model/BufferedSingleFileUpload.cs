using System.ComponentModel.DataAnnotations;

namespace AlexIA.Frontend.Model
{
    public class BufferedSingleFileUpload
    {
        [Required]
        [Display(Name = "CV")]
        public IFormFile FormFile { get; set; }

    }
}
