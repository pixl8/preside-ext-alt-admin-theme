component {

	public function configure( cachebox ) {
		arguments.cachebox.caches.adminMenuCache = arguments.cachebox.caches.adminMenuCache ?: {
			  provider = "preside.system.coldboxModifications.cachebox.CacheProvider"
			, properties = {
				  evictCount                     = 200
				, evictionPolicy                 = "LFU"
				, freeMemoryPercentageThreshold  = 0
				, maxObjects                     = 1000
				, objectDefaultLastAccessTimeout = 30
				, objectDefaultTimeout           = 120
				, objectStore                    = "ConcurrentStore"
				, reapFrequency                  = 10
				, useLastAccessTimeouts          = true
			  }
		};
	}
}