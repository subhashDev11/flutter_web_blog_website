{{flutter_js}}
{{flutter_build_config}}

// Manipulate the DOM to add a loading spinner will be rendered with this HTML:
// <div class="loading">
//   <div class="loader" />
// </div>
// Create the loading container

const loadingDiv = document.createElement('div');
loadingDiv.className = "loading";
document.body.appendChild(loadingDiv);

// Create the loader container
const loaderContainer = document.createElement('div');
loaderContainer.className = "loader-container";
loadingDiv.appendChild(loaderContainer);

// Add the logo image
const logoImg = document.createElement('img');
logoImg.src = "icons/Icon-192.png"; // Path to your logo
logoImg.alt = "AutoFormsAI Logo";
logoImg.className = "logo";
loaderContainer.appendChild(logoImg);

// Add the spinning loader
const loaderDiv = document.createElement('div');
loaderDiv.className = "loader";
loaderContainer.appendChild(loaderDiv);

// Add the loading text
const loadingText = document.createElement('p');
loadingText.className = "loading-text";
loadingText.textContent = "Loading AutoFormsAI Articles, please wait...";
loaderContainer.appendChild(loadingText);

// Customize the app initialization process
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();

    // Remove the loading spinner when the app runner is ready
    if (document.body.contains(loadingDiv)) {
      document.body.removeChild(loadingDiv);
    }
    await appRunner.runApp();
  }
});