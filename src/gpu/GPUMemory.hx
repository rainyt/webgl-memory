package gpu;

import haxe.Timer;
import openfl.display.BitmapData;
#if js
import haxe.Exception;
import js.lib.WeakRef;
#elseif cpp
import cpp.vm.WeakRef;
#end

/**
 * 适用于OpenLF的GPU内存统计
 * GPU Memory Statistics for OpenFL
 */
class GPUMemory {
	/**
	 * 位图引用关系
	 * Bitmap reference relationship
	 */
	public static var bitmapDatas:Array<WeakRef<BitmapData>> = [];

	/**
	 * GPU内存缓存记录大小
	 */
	private static var __gpuMemorySize:Int = 0;

	/**
	 * 是否支持弱引用
	 */
	private static var __isSupport:Null<Bool> = null;

	/**
	 * 是否初始化
	 */
	private static var __init = false;

	/**
	 * 是否自动更新内存大小
	 * Whether to automatically update memory size
	 */
	public static var autoUpdateMemorySize:Bool = true;

	/**
	 * 判断是否支持当前API
	 * @return Bool
	 */
	public static function isSupport():Bool {
		if (__isSupport != null)
			return __isSupport;
		#if js
		if (untyped window.WeakRef != null) {
			__isSupport = true;
		} else {
			trace("[WeakRef] Not support.");
			__isSupport = false;
		}
		#else
		__isSupport = true;
		#end
		return __isSupport;
	}

	/**
	 * 观察位图引用关系
	 * Observe bitmap reference relationships
	 * @param bitmapData 
	 */
	public static function which(bitmapData:BitmapData):Void {
		if (isSupport()) {
			bitmapDatas.push(new WeakRef(bitmapData));
			updateGPUMemorySize();
			if (!__init) {
				__init = true;
				run();
			}
		}
	}

	/**
	 * 每3秒更新一次
	 */
	private static function run():Void {
		if (!autoUpdateMemorySize)
			return;
		Timer.delay(() -> {
			updateGPUMemorySize();
			run();
		}, 3000);
	}

	/**
	 * 获得GPU的内存大小
	 * Get the memory size of the GPU
	 * @return Int
	 */
	public static function getGPUMemorySize():Int {
		if (!isSupport())
			return 0;
		return __gpuMemorySize;
	}

	/**
	 * 更新GPU内存大小
	 */
	public static function updateGPUMemorySize():Void {
		if (!isSupport())
			return;
		var size:Int = 0;
		bitmapDatas = bitmapDatas.filter(ref -> #if cpp ref.get() #else ref.deref() #end != null);
		for (ref in bitmapDatas) {
			var bitmapData:BitmapData = #if cpp ref.get() #else ref.deref() #end;
			if (bitmapData != null && @:privateAccess bitmapData.__texture != null) {
				size += bitmapData.getGPUMemory();
			}
		}
		__gpuMemorySize = size;
	}

	/**
	 * Get all bitmapData
	 * @return Array<BitmapData>
	 */
	public static function getBitmapDatas():Array<BitmapData> {
		if (!isSupport())
			return null;
		bitmapDatas = bitmapDatas.filter(ref -> #if cpp ref.get() #else ref.deref() #end != null);
		var array = [];
		for (ref in bitmapDatas) {
			var bitmapData:BitmapData = #if cpp ref.get() #else ref.deref() #end;
			array.push(bitmapData);
		}
		return array;
	}
}
