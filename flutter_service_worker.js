'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "ff501f8be692715e391cf9b9c9be98c5",
"version.json": "ec5cdc2e0f24ce90d49c3ff6de8419b6",
"index.html": "6877348044a8b5fe6a2977fd874507d6",
"/": "6877348044a8b5fe6a2977fd874507d6",
"main.dart.js": "b93f031bdd3d3e8cad993c672bd02ded",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "d6a058050022be375e1468875a798660",
"icons/Icon-192.png": "3a86c09504784475a646afd6c5882f36",
"icons/Icon-maskable-192.png": "3a86c09504784475a646afd6c5882f36",
"icons/Icon-maskable-512.png": "6d61656a93f1ea2710675500ba2ef9b6",
"icons/Icon-512.png": "6d61656a93f1ea2710675500ba2ef9b6",
"manifest.json": "82e83052ba69bbcc2d1faddaadaa1799",
"assets/AssetManifest.json": "31c0eba13d646e8ec5dcee6f433c952b",
"assets/NOTICES": "1a9b8d58c8893b2921c6f29480052d60",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "217af6aca9fbc91ffcbcf5df19e2c4c4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "261a821cb46e31dd30b2d9c0f4d80dac",
"assets/fonts/MaterialIcons-Regular.otf": "963ece958c1086509c620456f299786e",
"assets/assets/gowri/gowri.json": "0601aed671830ed945985e11c9949619",
"assets/assets/lagna/karthigai.json": "bbae0a0de11f0961f4887f889d446dc9",
"assets/assets/lagna/margazhi.json": "cce6cbb1910cf91e9669965819911661",
"assets/assets/lagna/avani.json": "ef7a14d736fe7c657461c1005f6e61b6",
"assets/assets/lagna/generate_lagna_json.py": "f40f59b650399adcba4b6383e100a6a7",
"assets/assets/lagna/aippasi.json": "e8afe913d7831b98bfd6c5751333dfe6",
"assets/assets/lagna/purattasi.json": "ee3b8990ec783632116e24435146932f",
"assets/assets/lagna/maasi.json": "5bd19a5a2c62cbc25e1eacf1b153a795",
"assets/assets/lagna/aadi.json": "450f90d5470a969a425cdb023720d1a0",
"assets/assets/lagna/panguni.json": "c49b1adba2129607ecefa9d2f01c4754",
"assets/assets/lagna/aani.json": "96df889f80373c8fcaadcd6bf3ce422d",
"assets/assets/lagna/chittirai.json": "af7f052022cbcea670d9e8c9f92861c0",
"assets/assets/lagna/thai.json": "bfc445ff6ec51914ab31022418fedf15",
"assets/assets/lagna/vaikasi.json": "99a8d12ffaeb88c58b8eb6c3dc58894b",
"assets/assets/icon/icon_180.png": "81ef54341417c79d4b1fde68854926fc",
"assets/assets/icon/icon_87.png": "1bbf1cd157f4d5f6491b2adde4e5b199",
"assets/assets/icon/icon_96.png": "09d0bf71464ef2559805c41a193cdc28",
"assets/assets/icon/icon_144.png": "7f16101b63ae18cb49599aebfa54833a",
"assets/assets/icon/icon_192.png": "3a86c09504784475a646afd6c5882f36",
"assets/assets/icon/icon_40.png": "28910a281a231328dd54a4213f85907f",
"assets/assets/icon/icon_152.png": "86e5f1ca69f4eba1b8eb928c5dafa905",
"assets/assets/icon/icon_57.png": "cabee41b770e6d50bd80c9041ce6c5b8",
"assets/assets/icon/icon_80.png": "b8765dc257698119b28aca1aa504e166",
"assets/assets/icon/icon_120.png": "d69f579a7f08835995a0d432a5d82de9",
"assets/assets/icon/icon_32.png": "d6a058050022be375e1468875a798660",
"assets/assets/icon/icon_20.png": "4406f458f4d855f7e20f8dfff157e23c",
"assets/assets/icon/icon_114.png": "1cc9ba1228f1668adfb8835cdb7d811d",
"assets/assets/icon/icon_128.png": "802740802ac463300555cedb6016b042",
"assets/assets/icon/nimitham_logo.svg": "bc0c92b499659be5ac8bf694ddde015c",
"assets/assets/icon/icon_512.png": "6d61656a93f1ea2710675500ba2ef9b6",
"assets/assets/icon/icon_16.png": "d5d713410e30549cd02147ae3275480e",
"assets/assets/icon/icon_29.png": "e2c9c311a42add60600f1c77d9db4960",
"assets/assets/icon/icon_72.png": "715c0266ecee0ae3feeb57beeeebbc88",
"assets/assets/icon/icon_1024.png": "6f6270357001e5038bf36526e8dcbead",
"assets/assets/icon/icon_58.png": "3afbd6eff4a65dffce831d053c25a1b2",
"assets/assets/icon/icon_64.png": "f07e0c3392567705181d9c07e2e7c577",
"assets/assets/icon/icon_48.png": "40853bcacbbe53f55c8f0088e1032585",
"assets/assets/icon/icon_60.png": "c33bcfdf5a056542c5238807fa911c70",
"assets/assets/icon/icon_167.png": "c676430bee727f03ecfeb14e61ffc28e",
"assets/assets/icon/icon_76.png": "fecaa2bb9d15a2d16814e8fc95700705",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
