function show_metadata()
	local title = mp.get_property("metadata/title")
	if title then
		mp.msg.info("Title: " .. title)
	end

	local synopsis = mp.get_property("metadata/synopsis")
	if synopsis then
		mp.msg.info("Synopsis: " .. synopsis)
	end
	local summary = mp.get_property("metadata/summary")
	if summary then
		mp.msg.info("Summary: " .. summary)
	end

	local air_date = mp.get_property("metadata/date")
	if air_date then
		mp.msg.info("Air Date: " .. air_date)
	end

	local series_id = mp.get_property("metadata/series_id")
	local episode_id = mp.get_property("metadata/episode_id")
	if series_id and episode_id then
		mp.msg.info("Series ID: " .. series_id)
		mp.msg.info("Episode ID: " .. episode_id)
	end
end

mp.register_event("file-loaded", show_synopsis)
