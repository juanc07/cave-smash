package idv.cjcat.stardust.common.initializers {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.handlers.ParticleHandler;
	import idv.cjcat.stardust.common.particles.Particle;
	
	public class Handler extends Initializer {
		
		private var _particleHandler:ParticleHandler;
		
		public function Handler(particleHandler:ParticleHandler) {
			_particleHandler = particleHandler;
			onAdd.add(onAddListener);
			onRemove.add(onRemoveListener);
		}
		
		override public function initialize(particle:Particle):void {
			particle.handler = _particleHandler;
		}
		
		private function onAddListener(emitter:Emitter, initializer:Initializer):void {
			emitter.onStepBegin.add(_particleHandler.stepBegin);
		}
		
		private function onRemoveListener(emitter:Emitter, initializer:Initializer):void {
			emitter.onStepEnd.remove(_particleHandler.stepEnd);
		}
	}
}