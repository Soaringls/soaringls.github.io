<table>
  <tr>
    <td><img src="image_url_1" width="100" height="100" alt="Image 1"></td>
    <td><img src="image_url_2" width="100" height="100" alt="Image 2"></td>
  </tr>
  <tr>
    <td><img src="image_url_3" width="100" height="100" alt="Image 3"></td>
    <td><img src="image_url_4" width="100" height="100" alt="Image 4"></td>
  </tr>
</table>

![Alt text](mapping_match_scan2submap.png)
![Alt text](mapping_match_sub2submap.png)

![Alt text](mapping_pairs2.png)
![Alt text](mapping_v2.png)

![Alt text](mapping_v1v2_ground.png)

### 雷达坐标系到图像坐标系的转换
假设雷达水平视场角为 $\beta_G$, 水平分辨率为 $r_{\beta}$, 垂直视场角为 $\alpha_G$, 垂直分辨率为 $r_{\alpha}$, 对于点云中任意一点 $P(x,y,z)$, 其在图像系下坐标$P(u,v)$计算如下


水平方位角  $\quad \beta = arctan(\dfrac{y}{x}) \\\\
u = \dfrac{\beta_G - \beta}{r_{\beta}}$

P与雷达坐标系xy平面夹角 $\quad \alpha =arctan(\dfrac{z}{ \sqrt{x^2+y^2}})$

$$
v = 
\begin{cases}
      \dfrac{\alpha_G  - \alpha}{r_{\alpha}} \quad z > 0 \\\\
      \dfrac{\alpha_G  + \alpha}{r_{\alpha}} \quad z < 0 
\end{cases}
$$
