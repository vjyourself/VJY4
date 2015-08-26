package neuralbox2.wave{
	public function hitTestPointRectangle(x0,y0,x1,y1,dimX1,dimY1):Boolean{
		return ((x0>=x1)&&(x0<=(x1+dimX1)))&&((y0>=y1)&&(y0<=(y1+dimY1)))
	}
}