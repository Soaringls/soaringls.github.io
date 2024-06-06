
## IMU噪声参数
基于IMU手册所给参数合理设置进行对应参数计算

- 参考高翔新书<自动驾驶和机器人中slam技术>
  
- [零偏不稳定性描述1](https://www.advancednavigation.com/tech-articles/inertial-measurement-unit-imu-an-introduction/#intro)
  
- [惯性器件的零偏误差有哪些呢？-武汉大学多源智能导航实验室](http://www.i2nav.com/index/newListDetail_zw.do?newskind_id=13a8654e060c40c69e5f3d4c13069078&newsinfo_id=43bf2e0076d947aba8b58725ad8f5c15)


由连续时间方差计算离散时间方差:

$$
\begin{align}       
    \sigma_g(k) = \dfrac{1}{\sqrt{\Delta t}} \sigma_g  \quad ,\sigma_a(k) = \dfrac{1}{\sqrt{\Delta t}} \sigma_a \\\\
    \sigma_{bg}(k) =\sigma_{bg} \cdot \sqrt{\Delta t}  \quad ,\sigma_{ba}(k) =\sigma_{ba} \cdot \sqrt{\Delta t} 
\end{align}     
$$

如
$$
 \sigma_g=\sigma_g(k)\cdot \sqrt{\Delta t} \quad  \to \quad \dfrac{rad}{s} \cdot \sqrt{s}=\dfrac{rad}{\sqrt{s}}  
$$

$$
 \sigma_ghz = \dfrac{rad}{s\sqrt{Hz}} = \dfrac{rad}{s \sqrt{\dfrac{1}{s}}}=\dfrac{rad}{\sqrt{s}}
$$


|                              | gyro                                       | gyro bias                                     | accel                                      | accel bias                                  |
| ---------------------------- | ------------------------------------------ | --------------------------------------------- | ------------------------------------------ | ------------------------------------------- |
| imu params used              | $\sigma_g(k) \to \dfrac{rad}{s}$           | $\sigma_{bg}(k) \to \dfrac{rad}{s}$           | $\sigma_a(k) \to \dfrac{m}{s^2}$           | $\sigma_{ba}(k) \to \dfrac{m}{s^2}$         |
| 连续时间方差                 | $\sigma_g \to   \dfrac{rad}{\sqrt{s}}$     | $\sigma_{bg} \to   \dfrac{rad}{s\sqrt{s}}$    | $\sigma_{a} \to   \dfrac{m}{s\sqrt{s}}$    | $\sigma_{ba} \to   \dfrac{m}{s^2\sqrt{s}}$  |
| $\dfrac{1}{\Delta t} \to Hz$ | $\sigma_{g}hz \to \dfrac{rad}{s\sqrt{Hz}}$ | $\sigma_{bg}hz \to \dfrac{rad}{s^2\sqrt{Hz}}$ | $\sigma_{a}hz \to \dfrac{m}{s^2\sqrt{Hz}}$ | $\sigma_{ba}hz \to \dfrac{m}{s^3\sqrt{Hz}}$ |


### gyro 陀螺仪噪声密度

#### Rn(Rate noise density)
角速度随机游走的标准差，单位为$rad/s$

如ASM330手册给出该指标为$5 mdps/\sqrt{Hz}$,即$0.005deg  /\sqrt{Hz}$,这意味着在1赫兹的频率范围内，每秒的随机角速度变化在平均情况下为5毫度,即 0.005 deg. 如果imu频率为100hz,采样间隔$\Delta t=0.01s$,则离散状态下角速度的随机游走方差为：
  
  $$
   \sigma_g(k) \to 0.005deg  /\sqrt{Hz} =  \dfrac{0.005deg}{\sqrt{\dfrac{1}{\Delta t}}} = 0.005* 10 deg/s = 0.000872 rad/s
  $$ 

#### ARW(angular random walk)
即角度随机游走,陀螺仪白噪声单位为$deg/\sqrt{h}$

- ASM330手册给出ARW值，连续时间噪声单位为: $\sigma_g =0.21  deg/\sqrt{h}$, 则离散状态下角度的随机游走方差为：
  
  $$
   \sigma_g(k) \to  \dfrac{0.21deg/\sqrt{3600s}}{\sqrt{\Delta t}}=\dfrac{0.21/60}{\sqrt{0.01}} = 6.108e-4 \space deg/s
  $$
  

- 北云手册ARW，连续时间角度随机游走为: $0.1deg/ \sqrt{h}$, 则以100hz采样频率进行换算为: $\sigma_g(k) =\dfrac{d2r(0.1deg/60)}{\sqrt{\Delta t}}   =  0.0002908 \quad rad/s$, 峰峰值取6倍$\sigma_g(k)$为0.00174532

### gyro BI(Bias Instability)
即可陀螺仪的零偏不稳定性，也可角速度的零偏不稳定性。
ASM330手册给出零偏不稳定性值，连续时间噪声单位为: $\sigma_{bg} =3deg/h=\dfrac{3}{3600} deg/s$, 则离散状态下角速度的随机游走方差为：$\sigma_{bg}(k) = \sigma_{bg}\cdot \sqrt{\Delta t}$, 如100hz采样频率,时间间隔 $\Delta t = 0.01s$

$$
\sigma_{bg}(k) = \sigma_{bg} \sqrt{0.01} = 1.45e^{-6} rad/s
$$ 

根据牛小骥教授说法，实际国军标参数为手册放大5-10倍，则取值$1.4544e^{-5} rad/s$进行计算，由于该值描述的是连续状态下bias不稳定性，遵循$\dot{b}_g \sim N(0,\sigma^2)$


### accel 加速度计噪声密度
Acceleration noise density,单位为$m/s^2$

- 北云手册给出`速度随机游走` 为$0.035 m/s/\sqrt{h} = \dfrac{0.035}{\sqrt{3600s}}m/s/\sqrt{s}=0.0005833m/s/\sqrt{s}$, 以100hz采样频率,时间间隔 $\Delta t = 0.01s$ 计算离散状态下加速度的随机游走方差为:
  
  $$    
   \sigma_a(k) = \dfrac{\sigma_a}{\sqrt{\Delta t}}   = 0.005833 \space m/s^2
  $$
峰峰值取6倍$\sigma_a(k)$为 $0.03498 m/s^2$
  

- ASM330手册加速度计为: $\sigma_{a}hz =60 \space ug/\sqrt{hz}$，$1ug=10^{-6}m/s^2=1e{-6}m/s^2$，对应离散时间噪声计算结果为：

$$
 \sigma_{a}(k) =\dfrac{\sigma_{a}hz * 10^{-6} * 9.8}{\sqrt{\Delta t}}=\dfrac{60* 10^{-6} * 9.8}{\sqrt{0.01}}= 5.88e-3 \space m/s^2
$$
 
 
### accel BI(Bias Instability)
即加速度计的零偏不稳定性。

取 75ug作为经典值$1ug=10^{-6}m/s^2=1e{-6}m/s^2$，其连续状态下$\sigma_{ba} =75\times 10^{-6} \times  9.8 =7.35e-4 m/s^2$

100hz采样, 时间间隔 $\Delta t = 0.01s$, $\sigma_{ba}(k) = \sigma_{ba} \cdot \sqrt{\Delta t} = 7.35e-5 \space m/s^2$
 