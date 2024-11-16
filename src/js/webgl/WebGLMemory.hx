package js.webgl;

import lime.graphics.opengl.GL;
import js.html.webgl.Buffer;
import js.html.webgl.Texture;

class WebGLMemory {
	public static function getMemoryInfo():WebGLMemoryInfo {
		var ext:Dynamic = GL.getExtension('GMAN_webgl_memory');
		if (ext != null) {
			// memory info
			// trace("ext = ", ext);
			var info = ext.getMemoryInfo();
			trace("info = ", info);
			// every texture, it's size, a stack of where it was created and a stack of where it was last updated.
			// var textures = ext.getResourcesInfo(Texture);
			// every buffer, it's size, a stack of where it was created and a stack of where it was last updated.
			// var buffers = ext.getResourcesInfo(Buffer);
			// trace(info, textures, buffers);
		}
		return null;
	}
}
