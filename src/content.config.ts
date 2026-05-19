import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const works = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/works' }),
  schema: z.object({
    title: z.string(),
    location: z.string(),
    area: z.number().optional(),
    category: z.enum(['주거', '카페', '상업공간', '사무공간', '기타']),
    date: z.date(),
    thumbnail: z.string(),
    gallery: z.array(z.string()).optional(),
    specs: z.string().optional(),
    duration: z.string().default('1일 완공'),
    featured: z.boolean().default(false),
  }),
});

export const collections = { works };