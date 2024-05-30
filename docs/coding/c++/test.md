
### 正太分布

```cpp
double horizontal_noise_variance=4;

std::default_random_engine genrator();
std::normal_distribution<double> horizontal_noise_distribution(0.0, std::sqrt(horizontal_noise_variance));

double random_noise = horizontal_noise_distribution(genrator);
```