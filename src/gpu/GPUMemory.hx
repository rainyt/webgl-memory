package gpu;

import openfl.display.BitmapData;
#if js
import js.lib.WeakRef;
#elseif cpp
#end

/**
 * GPU内存统计
 */
class GPUMemory {
	/**
	 * 位图引用关系
	 */
	public static var bitmapDatas:Array<WeakRef<BitmapData>>;

	/**
	 * 观察位图引用关系
	 * @param bitmapData 
	 */
	public static function which(bitmapData:BitmapData):Void {
		bitmapDatas.push(new WeakRef(bitmapData));
	}

	/**
	 * 获得GPU的内存大小
	 * @return Int
	 */
	public static function getGPUMemorySize():Int {
		var size:Int = 0;
		for (ref in bitmapDatas) {
			var bitmapData:BitmapData = ref.deref();
			if (bitmapData != null) {
				size += bitmapData.width * bitmapData.height * 4;
			}
		}
		return size;
	}
}
