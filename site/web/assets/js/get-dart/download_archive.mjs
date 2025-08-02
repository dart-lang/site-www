// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _4: (o, c) => o instanceof c,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._8(f,arguments.length,x0,x1) }),
      _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => { x0[x1] = x2 },
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _73: (s) => +s,
      _76: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _77: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _78: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _82: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _83: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _99: s => JSON.stringify(s),
      _100: s => printToConsole(s),
      _101: (o, p, r) => o.replaceAll(p, () => r),
      _102: (o, p, r) => o.replace(p, () => r),
      _103: Function.prototype.call.bind(String.prototype.toLowerCase),
      _104: s => s.toUpperCase(),
      _105: s => s.trim(),
      _108: (string, times) => string.repeat(times),
      _109: Function.prototype.call.bind(String.prototype.indexOf),
      _110: (s, p, i) => s.lastIndexOf(p, i),
      _111: (string, token) => string.split(token),
      _112: Object.is,
      _113: o => o instanceof Array,
      _123: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _124: a => a.length,
      _126: (a, i) => a[i],
      _127: (a, i, v) => a[i] = v,
      _132: o => o instanceof Uint8Array,
      _133: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _134: o => o instanceof Int8Array,
      _135: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _136: o => o instanceof Uint8ClampedArray,
      _137: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _138: o => o instanceof Uint16Array,
      _139: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _140: o => o instanceof Int16Array,
      _141: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _142: o => o instanceof Uint32Array,
      _143: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _144: o => o instanceof Int32Array,
      _145: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _148: o => o instanceof Float32Array,
      _149: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _150: o => o instanceof Float64Array,
      _151: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _152: (t, s) => t.set(s),
      _154: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _156: o => o.buffer,
      _157: o => o.byteOffset,
      _158: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _159: (b, o) => new DataView(b, o),
      _160: (b, o, l) => new DataView(b, o, l),
      _161: Function.prototype.call.bind(DataView.prototype.getUint8),
      _162: Function.prototype.call.bind(DataView.prototype.setUint8),
      _163: Function.prototype.call.bind(DataView.prototype.getInt8),
      _164: Function.prototype.call.bind(DataView.prototype.setInt8),
      _165: Function.prototype.call.bind(DataView.prototype.getUint16),
      _166: Function.prototype.call.bind(DataView.prototype.setUint16),
      _167: Function.prototype.call.bind(DataView.prototype.getInt16),
      _168: Function.prototype.call.bind(DataView.prototype.setInt16),
      _169: Function.prototype.call.bind(DataView.prototype.getUint32),
      _170: Function.prototype.call.bind(DataView.prototype.setUint32),
      _171: Function.prototype.call.bind(DataView.prototype.getInt32),
      _172: Function.prototype.call.bind(DataView.prototype.setInt32),
      _177: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _178: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _179: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _180: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _197: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _204: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _205: (x0,x1) => globalThis.fetch(x0,x1),
      _206: (x0,x1) => x0.get(x1),
      _207: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._207(f,arguments.length,x0,x1,x2) }),
      _208: (x0,x1) => x0.forEach(x1),
      _210: () => new AbortController(),
      _211: x0 => x0.getReader(),
      _212: x0 => x0.read(),
      _213: x0 => x0.cancel(),
      _220: (x0,x1) => x0.createElement(x1),
      _222: (x0,x1) => x0.querySelector(x1),
      _223: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._223(f,arguments.length,x0) }),
      _225: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _226: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _227: x0 => x0.preventDefault(),
      _234: (x0,x1) => x0.item(x1),
      _235: (x0,x1,x2) => x0.createElementNS(x1,x2),
      _236: (x0,x1) => x0.item(x1),
      _237: (x0,x1,x2) => x0.replaceChild(x1,x2),
      _238: (x0,x1) => x0.append(x1),
      _239: (x0,x1) => x0.removeAttribute(x1),
      _240: x0 => new Text(x0),
      _241: (x0,x1) => x0.replaceWith(x1),
      _242: (x0,x1) => x0.item(x1),
      _243: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _244: (x0,x1) => x0.removeChild(x1),
      _245: (x0,x1) => x0.hasAttribute(x1),
      _246: (x0,x1) => x0.getAttribute(x1),
      _247: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _248: (x0,x1) => x0.error(x1),
      _265: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _266: (x0,x1) => x0.exec(x1),
      _267: (x0,x1) => x0.test(x1),
      _268: x0 => x0.pop(),
      _270: o => o === undefined,
      _272: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _275: o => o instanceof RegExp,
      _276: (l, r) => l === r,
      _277: o => o,
      _278: o => o,
      _279: o => o,
      _280: b => !!b,
      _281: o => o.length,
      _283: (o, i) => o[i],
      _284: f => f.dartFunction,
      _285: () => ({}),
      _286: () => [],
      _291: (o, p) => o[p],
      _292: (o, p, v) => o[p] = v,
      _293: (o, m, a) => o[m].apply(o, a),
      _295: o => String(o),
      _296: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      _297: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        return 18;
      },
      _302: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _303: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _306: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _312: x0 => new ArrayBuffer(x0),
      _315: x0 => x0.index,
      _317: x0 => x0.flags,
      _318: x0 => x0.multiline,
      _319: x0 => x0.ignoreCase,
      _320: x0 => x0.unicode,
      _321: x0 => x0.dotAll,
      _322: (x0,x1) => { x0.lastIndex = x1 },
      _327: x0 => x0.random(),
      _330: () => globalThis.Math,
      _331: Function.prototype.call.bind(Number.prototype.toString),
      _332: Function.prototype.call.bind(BigInt.prototype.toString),
      _333: Function.prototype.call.bind(Number.prototype.toString),
      _1400: x0 => x0.checked,
      _1407: x0 => x0.files,
      _1450: x0 => x0.type,
      _1454: x0 => x0.value,
      _1455: (x0,x1) => { x0.value = x1 },
      _1456: x0 => x0.valueAsDate,
      _1458: x0 => x0.valueAsNumber,
      _1541: x0 => x0.selectedOptions,
      _1544: x0 => x0.value,
      _1545: (x0,x1) => { x0.value = x1 },
      _1564: x0 => x0.value,
      _1603: x0 => x0.value,
      _2170: () => globalThis.window,
      _2233: x0 => x0.navigator,
      _2618: x0 => x0.appVersion,
      _4737: x0 => x0.target,
      _4777: x0 => x0.signal,
      _4786: x0 => x0.length,
      _4788: x0 => x0.length,
      _4832: x0 => x0.parentNode,
      _4834: x0 => x0.childNodes,
      _4837: x0 => x0.previousSibling,
      _4838: x0 => x0.nextSibling,
      _4841: x0 => x0.textContent,
      _4842: (x0,x1) => { x0.textContent = x1 },
      _4846: () => globalThis.document,
      _5254: x0 => x0.namespaceURI,
      _5257: x0 => x0.tagName,
      _5265: x0 => x0.attributes,
      _5391: x0 => x0.length,
      _5395: x0 => x0.name,
      _6599: x0 => x0.value,
      _6601: x0 => x0.done,
      _7303: x0 => x0.url,
      _7305: x0 => x0.status,
      _7307: x0 => x0.statusText,
      _7308: x0 => x0.headers,
      _7309: x0 => x0.body,
      _11657: () => globalThis.console,
      _11681: () => globalThis.Element,
      _11682: () => globalThis.HTMLInputElement,
      _11683: () => globalThis.HTMLAnchorElement,
      _11684: () => globalThis.HTMLSelectElement,
      _11685: () => globalThis.HTMLTextAreaElement,
      _11686: () => globalThis.HTMLOptionElement,
      _11687: () => globalThis.Text,
      _11689: () => globalThis.window,
      _11690: x0 => x0.navigator,
      _11692: x0 => x0.language,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
