using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace Az204Labs.WebApp.Pages
{
    using Azure.Core;
    using Azure.Identity;
    using Azure.Security.KeyVault.Secrets;
    using Microsoft.Azure.KeyVault;
    using Microsoft.Extensions.Configuration;

    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;

        [BindProperty]
        public string SecretValue { get; set; }

        public IndexModel(ILogger<IndexModel> logger, IConfiguration config)
        {
            SecretClientOptions options = new SecretClientOptions()
            {
                Retry =
                {
                    Delay= TimeSpan.FromSeconds(2),
                    MaxDelay = TimeSpan.FromSeconds(16),
                    MaxRetries = 5,
                    Mode = RetryMode.Exponential
                }
            };
            var client = new SecretClient(new Uri(config["KeyVaultUri"]), new DefaultAzureCredential(), options);
            //client.SetSecret(new KeyVaultSecret("fff", "ddd"));
            KeyVaultSecret kvSecret = client.GetSecret("TestSecret");
            SecretValue = kvSecret.Value;
            _logger = logger;
        }

        public void OnGet()
        {

        }
    }
}
