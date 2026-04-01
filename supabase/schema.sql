-- ============================================================
-- Society260 Supabase Schema
-- Run this in the Supabase SQL editor (project > SQL editor)
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── PROFILES ────────────────────────────────────────────────
-- Extends auth.users with app-specific fields
create table public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  username     text unique not null,
  display_name text not null,
  avatar_url   text,
  bio          text,
  membership   text not null default 'free' check (membership in ('free', 'pro', 'advocate')),
  followers    int  not null default 0,
  following    int  not null default 0,
  post_count   int  not null default 0,
  is_admin     boolean not null default false,
  created_at   timestamptz not null default now()
);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)),
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─── POSTS ───────────────────────────────────────────────────
create table public.posts (
  id           uuid primary key default uuid_generate_v4(),
  author_id    uuid not null references public.profiles(id) on delete cascade,
  type         text not null default 'text' check (type in ('text', 'image', 'video', 'audio', 'mixed')),
  text_content text,
  media_urls   text[]  default '{}',
  audio_url    text,
  tags         text[]  default '{}',
  likes        int     not null default 0,
  comments     int     not null default 0,
  reposts      int     not null default 0,
  is_pinned    boolean not null default false,
  created_at   timestamptz not null default now()
);

create table public.post_likes (
  post_id    uuid references public.posts(id) on delete cascade,
  user_id    uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

-- Auto-update likes count
create or replace function public.update_post_likes()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update public.posts set likes = likes + 1 where id = new.post_id;
  elsif TG_OP = 'DELETE' then
    update public.posts set likes = likes - 1 where id = old.post_id;
  end if;
  return null;
end;
$$;

create trigger on_post_like
  after insert or delete on public.post_likes
  for each row execute procedure public.update_post_likes();

-- ─── EVENTS ──────────────────────────────────────────────────
create table public.events (
  id          uuid primary key default uuid_generate_v4(),
  title       text not null,
  description text,
  date        timestamptz not null,
  location    text,
  is_virtual  boolean not null default false,
  image_url   text,
  attendees   int  not null default 0,
  category    text not null default 'other' check (category in ('poetry', 'club260', 'music', 'workshop', 'code260', 'other')),
  is_past     boolean not null default false,
  created_by  uuid references public.profiles(id) on delete set null,
  created_at  timestamptz not null default now()
);

create table public.event_registrations (
  event_id   uuid references public.events(id) on delete cascade,
  user_id    uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);

-- Auto-update attendees count
create or replace function public.update_event_attendees()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update public.events set attendees = attendees + 1 where id = new.event_id;
  elsif TG_OP = 'DELETE' then
    update public.events set attendees = attendees - 1 where id = old.event_id;
  end if;
  return null;
end;
$$;

create trigger on_event_registration
  after insert or delete on public.event_registrations
  for each row execute procedure public.update_event_attendees();

-- ─── BLOG POSTS ──────────────────────────────────────────────
create table public.blog_posts (
  id           uuid primary key default uuid_generate_v4(),
  title        text not null,
  excerpt      text,
  content      text,
  author_id    uuid references public.profiles(id) on delete set null,
  cover_image  text,
  tags         text[]  default '{}',
  read_time    int not null default 5,
  views        int not null default 0,
  category     text not null default 'community' check (category in ('mentalHealth', 'fashion', 'events', 'code260', 'community')),
  published_at timestamptz default now(),
  is_published boolean not null default false,
  created_at   timestamptz not null default now()
);

-- ─── COURSES ─────────────────────────────────────────────────
create table public.courses (
  id             uuid primary key default uuid_generate_v4(),
  title          text not null,
  description    text,
  instructor     text not null,
  thumbnail_url  text,
  lessons        int  not null default 0,
  total_duration text,
  rating         numeric(3,1) not null default 0.0,
  enrolled       int  not null default 0,
  level          text not null default 'beginner' check (level in ('beginner', 'intermediate', 'advanced')),
  is_premium     boolean not null default false,
  topics         text[]  default '{}',
  created_at     timestamptz not null default now()
);

create table public.course_enrollments (
  course_id  uuid references public.courses(id) on delete cascade,
  user_id    uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (course_id, user_id)
);

-- Auto-update enrolled count
create or replace function public.update_course_enrolled()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update public.courses set enrolled = enrolled + 1 where id = new.course_id;
  elsif TG_OP = 'DELETE' then
    update public.courses set enrolled = enrolled - 1 where id = old.course_id;
  end if;
  return null;
end;
$$;

create trigger on_course_enrollment
  after insert or delete on public.course_enrollments
  for each row execute procedure public.update_course_enrolled();

-- ─── MESSAGES ────────────────────────────────────────────────
create table public.conversations (
  id           uuid primary key default uuid_generate_v4(),
  participant1 uuid not null references public.profiles(id) on delete cascade,
  participant2 uuid not null references public.profiles(id) on delete cascade,
  last_message text,
  last_message_at timestamptz,
  created_at   timestamptz not null default now(),
  unique(participant1, participant2)
);

create table public.messages (
  id              uuid primary key default uuid_generate_v4(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id       uuid not null references public.profiles(id) on delete cascade,
  type            text not null default 'text' check (type in ('text', 'image', 'audio', 'video')),
  text            text,
  media_url       text,
  audio_duration  int,
  is_read         boolean not null default false,
  sent_at         timestamptz not null default now()
);

-- Auto-update conversation last_message
create or replace function public.update_conversation_last_message()
returns trigger language plpgsql as $$
begin
  update public.conversations
  set last_message = new.text, last_message_at = new.sent_at
  where id = new.conversation_id;
  return new;
end;
$$;

create trigger on_message_sent
  after insert on public.messages
  for each row execute procedure public.update_conversation_last_message();

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

alter table public.profiles           enable row level security;
alter table public.posts              enable row level security;
alter table public.post_likes         enable row level security;
alter table public.events             enable row level security;
alter table public.event_registrations enable row level security;
alter table public.blog_posts         enable row level security;
alter table public.courses            enable row level security;
alter table public.course_enrollments enable row level security;
alter table public.conversations      enable row level security;
alter table public.messages           enable row level security;

-- profiles: anyone can read, only owner can update
create policy "Public profiles are viewable by everyone" on public.profiles for select using (true);
create policy "Users can update own profile"             on public.profiles for update using (auth.uid() = id);

-- posts: anyone can read, authenticated users can insert, only owner can delete
create policy "Posts are viewable by everyone"      on public.posts for select using (true);
create policy "Authenticated users can create posts" on public.posts for insert with check (auth.uid() = author_id);
create policy "Users can delete own posts"           on public.posts for delete using (auth.uid() = author_id);

-- post_likes: authenticated users can like/unlike
create policy "Anyone can view likes"         on public.post_likes for select using (true);
create policy "Authenticated users can like"  on public.post_likes for insert with check (auth.uid() = user_id);
create policy "Users can unlike their likes"  on public.post_likes for delete using (auth.uid() = user_id);

-- events: anyone can read, only admins can write (handled in app)
create policy "Events are viewable by everyone" on public.events for select using (true);
create policy "Admins can manage events"        on public.events for all using (
  exists (select 1 from public.profiles where id = auth.uid() and is_admin = true)
);

-- event_registrations
create policy "Anyone can view registrations"       on public.event_registrations for select using (true);
create policy "Authenticated users can register"    on public.event_registrations for insert with check (auth.uid() = user_id);
create policy "Users can unregister themselves"     on public.event_registrations for delete using (auth.uid() = user_id);

-- blog_posts: anyone can read published posts
create policy "Published posts are viewable by everyone" on public.blog_posts for select using (is_published = true);
create policy "Admins can manage blog posts"             on public.blog_posts for all using (
  exists (select 1 from public.profiles where id = auth.uid() and is_admin = true)
);

-- courses: anyone can read
create policy "Courses are viewable by everyone"    on public.courses for select using (true);
create policy "Admins can manage courses"           on public.courses for all using (
  exists (select 1 from public.profiles where id = auth.uid() and is_admin = true)
);

-- course_enrollments
create policy "Anyone can view enrollments"               on public.course_enrollments for select using (true);
create policy "Authenticated users can enroll"            on public.course_enrollments for insert with check (auth.uid() = user_id);
create policy "Users can unenroll themselves"             on public.course_enrollments for delete using (auth.uid() = user_id);

-- conversations: only participants can see
create policy "Participants can view their conversations" on public.conversations for select
  using (auth.uid() = participant1 or auth.uid() = participant2);
create policy "Authenticated users can create conversations" on public.conversations for insert
  with check (auth.uid() = participant1 or auth.uid() = participant2);

-- messages: only conversation participants can see
create policy "Participants can view messages" on public.messages for select
  using (
    exists (
      select 1 from public.conversations c
      where c.id = conversation_id
      and (c.participant1 = auth.uid() or c.participant2 = auth.uid())
    )
  );
create policy "Authenticated users can send messages" on public.messages for insert
  with check (auth.uid() = sender_id);
