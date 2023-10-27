extends TextureRect

var http_request = HTTPRequest.new()
var image: Image = Image.new()

func _ready():
	add_child(self.http_request)
	self.http_request.request_completed.connect(self._on_request_completed)


func set_image(url):
	self.http_request.request(url)

func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var err = self.image.load_jpg_from_buffer(body)
		if OK == err:
			self.image.load_jpg_from_buffer(body)
			var image_texture = ImageTexture.new()
			image_texture = ImageTexture.create_from_image(image)
			self.texture = image_texture
