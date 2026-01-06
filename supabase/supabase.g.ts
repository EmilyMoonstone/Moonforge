export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.1"
  }
  public: {
    Tables: {
      adventures: {
        Row: {
          campaign_id: string
          chapter_id: string
          content: Json
          created_at: string
          description: string | null
          id: string
          order_number: number
          title: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          chapter_id: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number: number
          title: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          chapter_id?: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "adventures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "adventures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "adventures_chapter_id_fkey"
            columns: ["chapter_id"]
            isOneToOne: false
            referencedRelation: "chapters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "adventures_chapter_id_fkey"
            columns: ["chapter_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["chapter_id"]
          },
        ]
      }
      campaign_access: {
        Row: {
          campaign_id: string
          created_at: string
          id: string
          role: string
          source_group_id: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          campaign_id: string
          created_at?: string
          id?: string
          role: string
          source_group_id?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          campaign_id?: string
          created_at?: string
          id?: string
          role?: string
          source_group_id?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "campaign_access_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "campaign_access_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "campaign_access_source_group_id_fkey"
            columns: ["source_group_id"]
            isOneToOne: false
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "campaign_access_source_group_id_fkey"
            columns: ["source_group_id"]
            isOneToOne: false
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
      campaigns: {
        Row: {
          content: Json
          created_at: string
          created_by: string
          description: string | null
          icon: string | null
          id: string
          title: string
          title_image: string | null
          updated_at: string
        }
        Insert: {
          content?: Json
          created_at?: string
          created_by: string
          description?: string | null
          icon?: string | null
          id?: string
          title: string
          title_image?: string | null
          updated_at?: string
        }
        Update: {
          content?: Json
          created_at?: string
          created_by?: string
          description?: string | null
          icon?: string | null
          id?: string
          title?: string
          title_image?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      chapters: {
        Row: {
          campaign_id: string
          content: Json
          created_at: string
          description: string | null
          id: string
          order_number: number
          title: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number: number
          title: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "chapters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chapters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
      characters: {
        Row: {
          abilities: Json
          armor_class: number | null
          avatar: string | null
          background: string | null
          classes: Json
          content: Json
          created_at: string
          data: Json
          dndbeyond_character_id: number | null
          dndbeyond_raw: Json
          group_id: string
          hit_points: number | null
          id: string
          level: number | null
          name: string
          race: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          abilities?: Json
          armor_class?: number | null
          avatar?: string | null
          background?: string | null
          classes?: Json
          content?: Json
          created_at?: string
          data?: Json
          dndbeyond_character_id?: number | null
          dndbeyond_raw?: Json
          group_id: string
          hit_points?: number | null
          id?: string
          level?: number | null
          name: string
          race?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          abilities?: Json
          armor_class?: number | null
          avatar?: string | null
          background?: string | null
          classes?: Json
          content?: Json
          created_at?: string
          data?: Json
          dndbeyond_character_id?: number | null
          dndbeyond_raw?: Json
          group_id?: string
          hit_points?: number | null
          id?: string
          level?: number | null
          name?: string
          race?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "characters_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "characters_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
      content_scopes: {
        Row: {
          adventure_id: string | null
          campaign_id: string
          chapter_id: string | null
          created_at: string
          id: string
          scene_id: string | null
          scope_type: string
          updated_at: string
        }
        Insert: {
          adventure_id?: string | null
          campaign_id: string
          chapter_id?: string | null
          created_at?: string
          id?: string
          scene_id?: string | null
          scope_type: string
          updated_at?: string
        }
        Update: {
          adventure_id?: string | null
          campaign_id?: string
          chapter_id?: string | null
          created_at?: string
          id?: string
          scene_id?: string | null
          scope_type?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "content_scopes_adventure_id_fkey"
            columns: ["adventure_id"]
            isOneToOne: false
            referencedRelation: "adventures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_adventure_id_fkey"
            columns: ["adventure_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["adventure_id"]
          },
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "content_scopes_chapter_id_fkey"
            columns: ["chapter_id"]
            isOneToOne: false
            referencedRelation: "chapters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_chapter_id_fkey"
            columns: ["chapter_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["chapter_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "scenes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_creature_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_encounter_expanded_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_encounter_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_item_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_location_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_organization_with_path"
            referencedColumns: ["scene_id"]
          },
          {
            foreignKeyName: "content_scopes_scene_id_fkey"
            columns: ["scene_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scene_id"]
          },
        ]
      }
      creatures: {
        Row: {
          ability_scores: Json
          actions: Json
          alignment: string | null
          armor_class: number | null
          avatar: string | null
          campaign_id: string
          challenge_rating: number | null
          condition_immunities: Json
          content: Json
          created_at: string
          creature_type: string | null
          damage_immunities: Json
          damage_resistances: Json
          description: string | null
          experience_points: number | null
          hit_dice: string | null
          hit_points: number | null
          id: string
          kind: string
          languages: Json
          legendary_actions: Json
          name: string
          organization_id: string | null
          raw: Json
          reactions: Json
          saving_throws: Json
          scope_id: string
          senses: Json
          size: string | null
          skills: Json
          source: string | null
          speed: Json
          spellcasting: Json
          subtype: string | null
          traits: Json
          updated_at: string
        }
        Insert: {
          ability_scores?: Json
          actions?: Json
          alignment?: string | null
          armor_class?: number | null
          avatar?: string | null
          campaign_id: string
          challenge_rating?: number | null
          condition_immunities?: Json
          content?: Json
          created_at?: string
          creature_type?: string | null
          damage_immunities?: Json
          damage_resistances?: Json
          description?: string | null
          experience_points?: number | null
          hit_dice?: string | null
          hit_points?: number | null
          id?: string
          kind: string
          languages?: Json
          legendary_actions?: Json
          name: string
          organization_id?: string | null
          raw?: Json
          reactions?: Json
          saving_throws?: Json
          scope_id: string
          senses?: Json
          size?: string | null
          skills?: Json
          source?: string | null
          speed?: Json
          spellcasting?: Json
          subtype?: string | null
          traits?: Json
          updated_at?: string
        }
        Update: {
          ability_scores?: Json
          actions?: Json
          alignment?: string | null
          armor_class?: number | null
          avatar?: string | null
          campaign_id?: string
          challenge_rating?: number | null
          condition_immunities?: Json
          content?: Json
          created_at?: string
          creature_type?: string | null
          damage_immunities?: Json
          damage_resistances?: Json
          description?: string | null
          experience_points?: number | null
          hit_dice?: string | null
          hit_points?: number | null
          id?: string
          kind?: string
          languages?: Json
          legendary_actions?: Json
          name?: string
          organization_id?: string | null
          raw?: Json
          reactions?: Json
          saving_throws?: Json
          scope_id?: string
          senses?: Json
          size?: string | null
          skills?: Json
          source?: string | null
          speed?: Json
          spellcasting?: Json
          subtype?: string | null
          traits?: Json
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      encounter_creatures: {
        Row: {
          campaign_id: string
          created_at: string
          creature_id: string
          encounter_id: string
          id: string
          initiative: number | null
          notes: string | null
          quantity: number
          updated_at: string
        }
        Insert: {
          campaign_id: string
          created_at?: string
          creature_id: string
          encounter_id: string
          id?: string
          initiative?: number | null
          notes?: string | null
          quantity?: number
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          created_at?: string
          creature_id?: string
          encounter_id?: string
          id?: string
          initiative?: number | null
          notes?: string | null
          quantity?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "encounter_creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "creatures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_creatures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "v_creature_with_path"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_encounter_id_fkey"
            columns: ["encounter_id"]
            isOneToOne: false
            referencedRelation: "encounters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_encounter_id_fkey"
            columns: ["encounter_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_encounters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_encounter_id_fkey"
            columns: ["encounter_id"]
            isOneToOne: false
            referencedRelation: "v_encounter_expanded_with_path"
            referencedColumns: ["encounter_id"]
          },
          {
            foreignKeyName: "encounter_creatures_encounter_id_fkey"
            columns: ["encounter_id"]
            isOneToOne: false
            referencedRelation: "v_encounter_with_path"
            referencedColumns: ["id"]
          },
        ]
      }
      encounters: {
        Row: {
          campaign_id: string
          content: Json
          created_at: string
          data: Json
          description: string | null
          id: string
          scope_id: string
          title: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          scope_id: string
          title: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          scope_id?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      group_members: {
        Row: {
          created_at: string
          group_id: string
          id: string
          role: string
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          group_id: string
          id?: string
          role: string
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          group_id?: string
          id?: string
          role?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "group_members_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "group_members_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
      groups: {
        Row: {
          created_at: string
          description: string | null
          dungeon_master_user_id: string
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          dungeon_master_user_id: string
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          dungeon_master_user_id?: string
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: []
      }
      items: {
        Row: {
          attunement: boolean
          campaign_id: string
          content: Json
          created_at: string
          data: Json
          description: string | null
          id: string
          image: string | null
          name: string
          rarity: string | null
          scope_id: string
          type: string | null
          updated_at: string
        }
        Insert: {
          attunement?: boolean
          campaign_id: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          image?: string | null
          name: string
          rarity?: string | null
          scope_id: string
          type?: string | null
          updated_at?: string
        }
        Update: {
          attunement?: boolean
          campaign_id?: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          image?: string | null
          name?: string
          rarity?: string | null
          scope_id?: string
          type?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      locations: {
        Row: {
          campaign_id: string
          content: Json
          created_at: string
          data: Json
          description: string | null
          id: string
          name: string
          scope_id: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          name: string
          scope_id: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          content?: Json
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          name?: string
          scope_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      maps: {
        Row: {
          campaign_id: string
          created_at: string
          data: Json
          description: string | null
          id: string
          image: string | null
          title: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          image?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          created_at?: string
          data?: Json
          description?: string | null
          id?: string
          image?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "maps_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "maps_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
      organizations: {
        Row: {
          avatar: string | null
          campaign_id: string
          content: Json
          created_at: string
          description: string | null
          hq_location_id: string | null
          id: string
          name: string
          scope_id: string
          type: string
          updated_at: string
        }
        Insert: {
          avatar?: string | null
          campaign_id: string
          content?: Json
          created_at?: string
          description?: string | null
          hq_location_id?: string | null
          id?: string
          name: string
          scope_id: string
          type: string
          updated_at?: string
        }
        Update: {
          avatar?: string | null
          campaign_id?: string
          content?: Json
          created_at?: string
          description?: string | null
          hq_location_id?: string | null
          id?: string
          name?: string
          scope_id?: string
          type?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_campaign_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_location_with_path"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      playing_campaigns: {
        Row: {
          campaign_id: string
          created_at: string
          group_id: string
          updated_at: string
        }
        Insert: {
          campaign_id: string
          created_at?: string
          group_id: string
          updated_at?: string
        }
        Update: {
          campaign_id?: string
          created_at?: string
          group_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "playing_campaigns_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "playing_campaigns_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "playing_campaigns_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: true
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "playing_campaigns_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: true
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
      scenes: {
        Row: {
          adventure_id: string
          campaign_id: string
          content: Json
          created_at: string
          description: string | null
          id: string
          order_number: number
          title: string
          updated_at: string
        }
        Insert: {
          adventure_id: string
          campaign_id: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number: number
          title: string
          updated_at?: string
        }
        Update: {
          adventure_id?: string
          campaign_id?: string
          content?: Json
          created_at?: string
          description?: string | null
          id?: string
          order_number?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "scenes_adventure_id_fkey"
            columns: ["adventure_id"]
            isOneToOne: false
            referencedRelation: "adventures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "scenes_adventure_id_fkey"
            columns: ["adventure_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["adventure_id"]
          },
          {
            foreignKeyName: "scenes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "scenes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
      session_logs: {
        Row: {
          content: Json
          created_at: string
          group_id: string
          id: string
          session_date: string | null
          session_number: number | null
          title: string | null
          updated_at: string
        }
        Insert: {
          content?: Json
          created_at?: string
          group_id: string
          id?: string
          session_date?: string | null
          session_number?: number | null
          title?: string | null
          updated_at?: string
        }
        Update: {
          content?: Json
          created_at?: string
          group_id?: string
          id?: string
          session_date?: string | null
          session_number?: number | null
          title?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "session_logs_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "session_logs_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
    }
    Views: {
      v_campaign_creatures: {
        Row: {
          ability_scores: Json | null
          actions: Json | null
          alignment: string | null
          armor_class: number | null
          avatar: string | null
          campaign_id: string | null
          challenge_rating: number | null
          condition_immunities: Json | null
          content: Json | null
          created_at: string | null
          creature_type: string | null
          damage_immunities: Json | null
          damage_resistances: Json | null
          description: string | null
          experience_points: number | null
          hit_dice: string | null
          hit_points: number | null
          id: string | null
          kind: string | null
          languages: Json | null
          legendary_actions: Json | null
          name: string | null
          organization_id: string | null
          raw: Json | null
          reactions: Json | null
          saving_throws: Json | null
          scope_id: string | null
          senses: Json | null
          size: string | null
          skills: Json | null
          source: string | null
          speed: Json | null
          spellcasting: Json | null
          subtype: string | null
          traits: Json | null
          updated_at: string | null
        }
        Insert: {
          ability_scores?: Json | null
          actions?: Json | null
          alignment?: string | null
          armor_class?: number | null
          avatar?: string | null
          campaign_id?: string | null
          challenge_rating?: number | null
          condition_immunities?: Json | null
          content?: Json | null
          created_at?: string | null
          creature_type?: string | null
          damage_immunities?: Json | null
          damage_resistances?: Json | null
          description?: string | null
          experience_points?: number | null
          hit_dice?: string | null
          hit_points?: number | null
          id?: string | null
          kind?: string | null
          languages?: Json | null
          legendary_actions?: Json | null
          name?: string | null
          organization_id?: string | null
          raw?: Json | null
          reactions?: Json | null
          saving_throws?: Json | null
          scope_id?: string | null
          senses?: Json | null
          size?: string | null
          skills?: Json | null
          source?: string | null
          speed?: Json | null
          spellcasting?: Json | null
          subtype?: string | null
          traits?: Json | null
          updated_at?: string | null
        }
        Update: {
          ability_scores?: Json | null
          actions?: Json | null
          alignment?: string | null
          armor_class?: number | null
          avatar?: string | null
          campaign_id?: string | null
          challenge_rating?: number | null
          condition_immunities?: Json | null
          content?: Json | null
          created_at?: string | null
          creature_type?: string | null
          damage_immunities?: Json | null
          damage_resistances?: Json | null
          description?: string | null
          experience_points?: number | null
          hit_dice?: string | null
          hit_points?: number | null
          id?: string | null
          kind?: string | null
          languages?: Json | null
          legendary_actions?: Json | null
          name?: string | null
          organization_id?: string | null
          raw?: Json | null
          reactions?: Json | null
          saving_throws?: Json | null
          scope_id?: string | null
          senses?: Json | null
          size?: string | null
          skills?: Json | null
          source?: string | null
          speed?: Json | null
          spellcasting?: Json | null
          subtype?: string | null
          traits?: Json | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_campaign_encounters: {
        Row: {
          campaign_id: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          scope_id: string | null
          title: string | null
          updated_at: string | null
        }
        Insert: {
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          scope_id?: string | null
          title?: string | null
          updated_at?: string | null
        }
        Update: {
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          scope_id?: string | null
          title?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_campaign_items: {
        Row: {
          attunement: boolean | null
          campaign_id: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          image: string | null
          name: string | null
          rarity: string | null
          scope_id: string | null
          type: string | null
          updated_at: string | null
        }
        Insert: {
          attunement?: boolean | null
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          image?: string | null
          name?: string | null
          rarity?: string | null
          scope_id?: string | null
          type?: string | null
          updated_at?: string | null
        }
        Update: {
          attunement?: boolean | null
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          image?: string | null
          name?: string | null
          rarity?: string | null
          scope_id?: string | null
          type?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_campaign_locations: {
        Row: {
          campaign_id: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          name: string | null
          scope_id: string | null
          updated_at: string | null
        }
        Insert: {
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          name?: string | null
          scope_id?: string | null
          updated_at?: string | null
        }
        Update: {
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          data?: Json | null
          description?: string | null
          id?: string | null
          name?: string | null
          scope_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_campaign_organizations: {
        Row: {
          avatar: string | null
          campaign_id: string | null
          content: Json | null
          created_at: string | null
          description: string | null
          hq_location_id: string | null
          id: string | null
          name: string | null
          scope_id: string | null
          type: string | null
          updated_at: string | null
        }
        Insert: {
          avatar?: string | null
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          description?: string | null
          hq_location_id?: string | null
          id?: string | null
          name?: string | null
          scope_id?: string | null
          type?: string | null
          updated_at?: string | null
        }
        Update: {
          avatar?: string | null
          campaign_id?: string | null
          content?: Json | null
          created_at?: string | null
          description?: string | null
          hq_location_id?: string | null
          id?: string | null
          name?: string | null
          scope_id?: string | null
          type?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_campaign_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_location_with_path"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_campaign_outline: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
        }
        Relationships: []
      }
      v_character_quick: {
        Row: {
          abilities: Json | null
          armor_class: number | null
          avatar: string | null
          classes: Json | null
          dndbeyond_character_id: number | null
          group_id: string | null
          hit_points: number | null
          id: string | null
          level: number | null
          name: string | null
          race: string | null
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          abilities?: Json | null
          armor_class?: number | null
          avatar?: string | null
          classes?: Json | null
          dndbeyond_character_id?: number | null
          group_id?: string | null
          hit_points?: number | null
          id?: string | null
          level?: number | null
          name?: string | null
          race?: string | null
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          abilities?: Json | null
          armor_class?: number | null
          avatar?: string | null
          classes?: Json | null
          dndbeyond_character_id?: number | null
          group_id?: string | null
          hit_points?: number | null
          id?: string | null
          level?: number | null
          name?: string | null
          race?: string | null
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "characters_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "groups"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "characters_group_id_fkey"
            columns: ["group_id"]
            isOneToOne: false
            referencedRelation: "v_group_dashboard"
            referencedColumns: ["group_id"]
          },
        ]
      }
      v_creature_with_path: {
        Row: {
          ability_scores: Json | null
          actions: Json | null
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          alignment: string | null
          armor_class: number | null
          avatar: string | null
          campaign_id: string | null
          campaign_title: string | null
          challenge_rating: number | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          condition_immunities: Json | null
          content: Json | null
          created_at: string | null
          creature_type: string | null
          damage_immunities: Json | null
          damage_resistances: Json | null
          description: string | null
          experience_points: number | null
          hit_dice: string | null
          hit_points: number | null
          id: string | null
          kind: string | null
          languages: Json | null
          legendary_actions: Json | null
          name: string | null
          organization_id: string | null
          path_order: string | null
          path_titles: string | null
          raw: Json | null
          reactions: Json | null
          saving_throws: Json | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          senses: Json | null
          size: string | null
          skills: Json | null
          source: string | null
          speed: Json | null
          spellcasting: Json | null
          subtype: string | null
          traits: Json | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "creatures_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_encounter_expanded_with_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          content: Json | null
          created_at: string | null
          creature_ac: number | null
          creature_cr: number | null
          creature_hp: number | null
          creature_id: string | null
          creature_kind: string | null
          creature_name: string | null
          data: Json | null
          description: string | null
          encounter_creature_id: string | null
          encounter_id: string | null
          initiative: number | null
          notes: string | null
          path_order: string | null
          path_titles: string | null
          quantity: number | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          title: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "creatures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_creatures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounter_creatures_creature_id_fkey"
            columns: ["creature_id"]
            isOneToOne: false
            referencedRelation: "v_creature_with_path"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_encounter_with_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          path_order: string | null
          path_titles: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          title: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "encounters_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_group_dashboard: {
        Row: {
          character_count: number | null
          dungeon_master_user_id: string | null
          group_id: string | null
          group_name: string | null
          playing_campaign_id: string | null
          session_log_count: number | null
        }
        Relationships: [
          {
            foreignKeyName: "playing_campaigns_campaign_id_fkey"
            columns: ["playing_campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "playing_campaigns_campaign_id_fkey"
            columns: ["playing_campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
      v_item_with_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          attunement: boolean | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          image: string | null
          name: string | null
          path_order: string | null
          path_titles: string | null
          rarity: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          type: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "items_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_location_with_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          content: Json | null
          created_at: string | null
          data: Json | null
          description: string | null
          id: string | null
          name: string | null
          path_order: string | null
          path_titles: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "locations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_organization_with_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          avatar: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          content: Json | null
          created_at: string | null
          description: string | null
          hq_location_id: string | null
          id: string | null
          name: string | null
          path_order: string | null
          path_titles: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          type: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_campaign_locations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_hq_location_fk"
            columns: ["hq_location_id"]
            isOneToOne: true
            referencedRelation: "v_location_with_path"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "content_scopes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_campaign"
            referencedColumns: ["scope_id"]
          },
          {
            foreignKeyName: "organizations_scope_id_fkey"
            columns: ["scope_id"]
            isOneToOne: false
            referencedRelation: "v_scope_path"
            referencedColumns: ["scope_id"]
          },
        ]
      }
      v_scope_campaign: {
        Row: {
          campaign_id: string | null
          scope_id: string | null
          scope_type: string | null
        }
        Relationships: [
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
      v_scope_path: {
        Row: {
          adventure_id: string | null
          adventure_order_number: number | null
          adventure_title: string | null
          campaign_id: string | null
          campaign_title: string | null
          chapter_id: string | null
          chapter_order_number: number | null
          chapter_title: string | null
          path_order: string | null
          path_titles: string | null
          scene_id: string | null
          scene_order_number: number | null
          scene_title: string | null
          scope_id: string | null
          scope_type: string | null
        }
        Relationships: [
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_scopes_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "v_campaign_outline"
            referencedColumns: ["campaign_id"]
          },
        ]
      }
    }
    Functions: {
      can_access_campaign: { Args: { cid: string }; Returns: boolean }
      can_edit_campaign: { Args: { cid: string }; Returns: boolean }
      encounter_campaign_id: { Args: { eid: string }; Returns: string }
      is_group_dm: { Args: { gid: string }; Returns: boolean }
      is_group_member: { Args: { gid: string }; Returns: boolean }
      refresh_campaign_access_for_group: {
        Args: { p_group_id: string }
        Returns: undefined
      }
      scope_campaign_id: { Args: { sid: string }; Returns: string }
    }
    Enums: {
      creature_kind: "npc" | "creature"
      organisation_type:
        | "faction"
        | "family"
        | "guild"
        | "cult"
        | "church"
        | "company"
        | "other"
      scope_type: "campaign" | "chapter" | "adventure" | "scene"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      creature_kind: ["npc", "creature"],
      organisation_type: [
        "faction",
        "family",
        "guild",
        "cult",
        "church",
        "company",
        "other",
      ],
      scope_type: ["campaign", "chapter", "adventure", "scene"],
    },
  },
} as const
