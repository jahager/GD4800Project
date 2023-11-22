extends VideoStreamPlayer

var video_filename: String
signal download_complete

var youtube_thread = Thread.new()

func find_download(search: String):
	print("Getting: " + search)
	self.video_filename = search + ".mp4"
	
	if FileAccess.file_exists("res://" + self.video_filename):
		play_video()
	else:
		$HTTPRequest.request("https://www.youtube.com/results?search_query="+search.uri_encode())

func _on_http_request_request_completed(result, response_code, headers, body):
	print("Respone received!")
	var response = body.get_string_from_utf8()
	var regex = RegEx.new()
	regex.compile("watch[?]v=.*?[\\\\][u]")
	var res = regex.search(response)
	if res:
		var watch_tag = res.get_string()
		var video_url = "https://www.youtube.com/" + watch_tag.substr(0, watch_tag.length()-2)
		
		self.youtube_thread.start(download_video.bind(video_url))

func download_video(url: String):
	print("Downloading: " + url)
	var resp = OS.execute("python", PackedStringArray( ["-m", "youtube_dl", url, "-f", "mp4", "-o", self.video_filename]))
	call_deferred("_download_done")

func _download_done():
	youtube_thread.wait_to_finish()
	emit_signal("download_complete")


func play_video():
	if FileAccess.file_exists("res://" + self.video_filename):
		print("playing")
		var new_stream = FFmpegVideoStream.new()
		new_stream.set_file("res://" + self.video_filename)
		$".".stream = new_stream
		$".".play()


