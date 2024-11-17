package gpu.macro;

import haxe.macro.Context;
import haxe.macro.Expr.Field;

#if macro
/**
 * 为openfl.display3D.Context3D添加gpu内存统计支持
 */
class Context3DMacro {
	public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (item in fields) {
			if (item.name == "get_totalGPUMemory") {
				switch item.kind {
					case FFun(f):
						switch f.expr.expr {
							case EBlock(exprs):
								exprs.insert(0, macro return gpu.GPUMemory.getGPUMemorySize());
							default:
						}
					default:
				}
			}
		}
		return fields;
	}
}
#end
