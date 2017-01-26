Material Design设计

FloatingActionButton代表在UI上浮动、用于特殊动作的圆形动作按钮。它载入时有两种大小：默认和mini，可以通过fabSize属性来控制其大小。可以通过其从ImageView继承来的方法设置其显示的图标。它的默认背景颜色取决于当前主题的colorAccent，可以通过它提供的setBackgroundTintList(ColorStateList)方法在运行时改变其背景颜色。

常用属性

  XML属性                   	对应方法	                                        
  app:elevation           	    	设置FAB未按下时的景深                            
  app:pressedTranslationZ 	    	设置FAB按下时的景深                             
  app:fabSize             	    	设置FAB的大小，默认只有normal和mini两种选项            
  app:borderWidth         	    	设置FAB的边框宽度（ 这个一般设置为0dp，不然的话在4.1的sdk上FAB会显示为正方形，而且在5.0以后的sdk没有阴影效果
  android:src             	    	设置FAB的drawaber                          
  app:rippleColor         	    	设置FAB按下时的背景色（ 当我使用com.android.support:design:23.2.0 的时候这个属性会失效，建议使用最新的 com.android.support:design:23.3.0' 或者适当的降低版本
  app:backgroundTint      	    	设置FAB未按下时的背景色                           
  app:layout_anchor       	    	设置FAB的锚点                                
  app:layout_anchorGravity	    	设置FAB相对于锚点的位置                           
  app:layout_behavior     	    	设置FAB的Behavior行为属性                      
​                          	    	                                        
​                          	    	                                        
​                          	    	                                        
​                          	    	                                        
​                          	    	                                        

实例：