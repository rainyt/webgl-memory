package gpu;

import openfl.display.BitmapData;
#if js
import js.lib.WeakRef;
#elseif cpp
import cpp.vm.WeakRef;
#end

/**
 * 适用于OpenLF的GPU内存统计
 * GPU Memory Statistics for OpenLF
 */
class GPUMemory {
	/**
	 * 位图引用关系
	 * Bitmap reference relationship
	 */
	public static var bitmapDatas:Array<WeakRef<BitmapData>>;

	/**
	 * GPU内存缓存记录大小
	 */
	private static var __gpuMemorySize:Int = 0;

	/**
	 * 观察位图引用关系
	 * Observe bitmap reference relationships
	 * @param bitmapData 
	 */
	public static function which(bitmapData:BitmapData):Void {
		bitmapDatas.push(new WeakRef(bitmapData));
		updateGPUMemorySize();
	}

	/**
	 * 获得GPU的内存大小
	 * Get the memory size of the GPU
	 * @return Int
	 */
	public static function getGPUMemorySize():Int {
		return __gpuMemorySize;
	}

	/**
	 * 更新GPU内存大小
	 */
	public static function updateGPUMemorySize():Void {
		var size:Int = 0;
		bitmapDatas = bitmapDatas.filter(ref -> #if cpp ref.get() #else ref.deref() #end != null);
		for (ref in bitmapDatas) {
			var bitmapData:BitmapData = #if cpp ref.get() #else ref.deref() #end;
			if (bitmapData != null && @:privateAccess bitmapData.__texture != null) {
				size += bitmapData.width * bitmapData.height * 4;
			}
		}
		__gpuMemorySize = size;
	}

	/**
	 * Get all bitmapData
	 * @return Array<BitmapData>
	 */
	public static function getBitmapDatas():Array<BitmapData> {
		bitmapDatas = bitmapDatas.filter(ref -> #if cpp ref.get() #else ref.deref() #end != null);
		var array = [];
		for (ref in bitmapDatas) {
			var bitmapData:BitmapData = #if cpp ref.get() #else ref.deref() #end;
			array.push(bitmapData);
		}
		return array;
	}
}
