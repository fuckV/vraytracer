//module raytrace
  
import math
import vec3
import rand

struct HitRecord {
  mut:
      t f32
      p vec3.Vec
      normal vec3.Vec
}

struct Sphere {
  centre vec3.Vec
  radius f32
}

fn (s Sphere) hit(r vec3.Ray, t_min f32, t_max f32) ?HitRecord {
    oc := r.a - s.centre
    a := r.b.dot(r.b)
    b := 2.0 * oc.dot(r.b)
    c := oc.dot(oc) - s.radius * s.radius
    discriminant := b * b - 4.0 * a * c
    temp := if (discriminant > 0) {
       (-b - math.sqrt(discriminant))/(2.0 * a)
    } else {
       (-b + math.sqrt(discriminant))/(2.0 * a)
    }
    if (temp > t_min && temp < t_max) {
      return HitRecord{temp, r.at(temp), (r.at(temp) - s.centre).div_scalar(s.radius)}
    }

    return error('No hit')
}

/*
interface Hitter {
  hit(r vec3.Ray, t_min f32, t_max f32) ?HitRecord
}
*/


struct HitList {
  mut:
    list []Sphere
    list_size int
}

fn (l HitList) hit(r vec3.Ray, t_min f32, t_max f32) ?HitRecord {
  mut closest := t_max
  mut hit_some := false
  mut hit_rec := HitRecord{}
  for i := 0; i < l.list_size; i++ {
    temp_rec := l.list[i].hit(r, t_min, closest) or { continue }
    closest = temp_rec.t
    hit_some = true
    hit_rec = temp_rec
  }
  if(hit_some) {
    return HitRecord{hit_rec.t, hit_rec.p, hit_rec.normal}
  } else {
   return error ('No hit')
  }
}

fn colour(r vec3.Ray, h HitList) vec3.Vec {
    rec := h.hit(r, 0.001, (1<<31) - 1) or {
      uv := r.make_unit()
      ic := 0.5*(uv.y() + 1.0)
      a := vec3.Vec{1.0, 1.0, 1.0}
      b :=  vec3.Vec{0.5, 0.7, 1.0}
      return a.mul_scalar(1.0 - ic) + b.mul_scalar(ic)
    }
      target := rec.p + rec.normal + random_point_in_sphere()
      return colour(vec3.Ray{rec.p, target}, h).mul_scalar(0.5)
/*                                           
      temp := rec.normal.make_unit()
      N := vec3.Vec{temp.x() + 1, temp.y() + 1, temp.z() + 1}
      return N.mul_scalar(0.5)
*/
}

struct Camera {
    origin vec3.Vec
    lower_left_corner vec3.Vec
    horizontal vec3.Vec
    vertical vec3.Vec
}

fn (c Camera) get_ray(u f32, v f32) vec3.Ray {
   return vec3.Ray{c.origin, c.lower_left_corner + c.horizontal.mul_scalar(u) + c.vertical.mul_scalar(v) - c.origin}
}

fn randf32() f32 {
   return f32(rand.next(255))/256.0
}

fn random_point_in_sphere() vec3.Vec {
   for {
     p := (vec3.Vec{randf32(), randf32(), randf32()} - vec3.Vec{1, 1, 1}).mul_scalar(2)
     if p.hypotenuse() < 1 {
        return vec3.Vec{p.x(), p.y(), p.z()}
     }
   }
}
       
fn main() {
    nx := 800
    ny := 400
    ns := 400
    println('P3')
    println('$nx $ny')
    println('255')
    llc := vec3.Vec{-2, -1, -1}
    hor := vec3.Vec{4, 0, 0}
    vert := vec3.Vec{0, 2, 0}
    origin := vec3.Vec{0, 0, 0}
    cam := Camera{origin, llc, hor, vert}
    mut h := HitList{[Sphere{vec3.Vec{0,0,0}, 0}; 2], 2}
    h.list[1] = Sphere{vec3.Vec{0, -100.5, -1}, 100}
    h.list[0] = Sphere{vec3.Vec{0, 0, -1}, 0.5}
    for j := ny - 1; j >= 0; j -- {
        for i := 0; i < nx; i++ {
            mut c := vec3.Vec{0, 0, 0}
            for s := 0; s < ns; s++ {
                u := (f32(i) + randf32())/f32(nx)
                v := (f32(j) + randf32())/f32(ny)
                r := cam.get_ray(u, v)
                c = c + colour(r, h)
            }
            c = c.div_scalar(ns)
            c = vec3.Vec{math.sqrt(c.x()), math.sqrt(c.y()), math.sqrt(c.z())}
            d := c.mul_scalar(255.99).to_rgb()
           println(d)
        }  
    }
}
