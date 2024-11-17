package gpu.macro;

import haxe.macro.Context;
import haxe.macro.Expr.Field;

#if macro
/**
 * 为 BitmapData 添加宏，gpu.GPUMemory.which(bitmapData)
 */
class BitmapDataMacro {
	public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (item in fields) {
			if (item.name == "new") {
				switch item.kind {
					case FFun(f):
						switch f.expr.expr {
							case EBlock(exprs):
								exprs.push(macro gpu.GPUMemory.which(this));
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
