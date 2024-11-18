# WebGL-Memory
- 在OpenFL项目中尝试记录BitmapData的数量，并模拟计算BitmapData的GPU使用量，通过弱引用标记GPU内存是否已被释放。
- Attempt to record the quantity of BitmapData in the OpenFL project and simulate the GPU usage of BitmapData, using weak references to mark whether GPU memory has been released.

# Use
You need to install the library first:
```shell
haxelib git webgl-memory https://github.com/rainyt/webgl-memory
```

Add to project.xml:
```xml
<haxelib name="webgl-memory" />
```

Read the GPU memory usage:
```haxe
var gpuMemory = this.stage.context3D.totalGPUMemory;
trace('GPU Memory: $gpuMemory');
```